import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanjeevani/functions/addreqpostfun.dart';
import 'package:sanjeevani/models/reqpostadd.dart';
import 'dart:io';
import 'package:sanjeevani/functions/navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormWidget extends StatefulWidget {
  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  var _nameController = TextEditingController();
  var _typeController = TextEditingController();
  var _ageController = TextEditingController();
  var _genderController = TextEditingController();
  var _urgencyConditionController = TextEditingController();
  var _urgencyICUController = TextEditingController();
  var _urgencyUnstableController = TextEditingController();
  var _urgencyComplicationsController = TextEditingController();
  var _locationController = TextEditingController();
  var _contentController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  double _urgencyScore = 0.0;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<int?> getuserid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  // Rule-based weights
  final Map<String, int> ruleBasedWeights = {
    'life_threatening': 5,
    'icu': 3,
    'instability': 1,
    'complications': 2,
  };

  // Urgency thresholds
  final Map<String, int> thresholds = {
    'critical': 15,
    'high': 10,
    'medium': 6,
    'low': 0,
  };

  double _ruleBasedScore(bool isLifeThreatening, bool isInICU, int instability,
      int complications) {
    double score = 0;
    score +=
        ruleBasedWeights['life_threatening']! * (isLifeThreatening ? 1 : 0);
    score += ruleBasedWeights['icu']! * (isInICU ? 1 : 0);
    score += ruleBasedWeights['instability']! * instability;
    score += ruleBasedWeights['complications']! * complications;
    return score.toDouble();
  }

  double _topsisScore(bool isLifeThreatening, bool isInICU, int instability,
      int complications) {
    final List<int> weights = ruleBasedWeights.values.toList();
    final double totalWeight = weights.reduce((a, b) => a + b).toDouble();

    // Normalize weights
    final normalizedWeights =
        weights.map((weight) => weight / totalWeight).toList();

    // Decision vector (1 if feature is true, else 0)
    final decisionVector = [
      isLifeThreatening ? 1 : 0,
      isInICU ? 1 : 0,
      instability,
      complications,
    ];

    // Compute weighted score
    double weightedScore = 0;
    for (int i = 0; i < decisionVector.length; i++) {
      weightedScore += decisionVector[i] * normalizedWeights[i];
    }

    // Scale the weighted score (similar to multiplying by 20 in Python)
    return weightedScore * 20;
  }

  void _calculateCombinedUrgency() {
    bool isLifeThreatening =
        _urgencyConditionController.text.trim().toLowerCase() == 'yes';
    bool isInICU = _urgencyICUController.text.trim().toLowerCase() == 'yes';
    int instability = int.tryParse(_urgencyUnstableController.text) ?? 0;
    int complications = int.tryParse(_urgencyComplicationsController.text) ?? 0;

    double ruleBased =
        _ruleBasedScore(isLifeThreatening, isInICU, instability, complications);
    double topsis =
        _topsisScore(isLifeThreatening, isInICU, instability, complications);

    // Calculate the average score
    double overallScore = (ruleBased + topsis) / 2;

    setState(() {
      _urgencyScore = overallScore;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Calculated Urgency Score: $_urgencyScore")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Text(
          'Add request',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildTextField(_nameController, 'Patient Name'),
              SizedBox(height: 10),
              _buildTextField(_typeController, 'Requesting for ?'),
              SizedBox(height: 10),
              _buildTextField(_ageController, 'Age'),
              SizedBox(height: 10),
              _buildTextField(_genderController, 'Gender'),
              SizedBox(height: 10),
              _buildUrgencyField(),
              SizedBox(height: 10),
              _buildTextField(_locationController, 'Your Location'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _calculateCombinedUrgency,
                child: Text("Calculate Urgency Score"),
              ),
              SizedBox(height: 10),
              Text(
                "Urgency Score: ${_calculateUrgency(_urgencyScore)}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _getUrgencyColor(_urgencyScore),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Add your medical prescription',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 10),
              _buildTextField(_contentController, 'Add more information',
                  maxLines: 3),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        int? userId = await getuserid();
                        if (userId != null) {
                          AddReqPost post = AddReqPost(
                            name: _nameController.text,
                            reqtype: _typeController.text,
                            age: _ageController.text,
                            gender: _genderController.text,
                            urgency: _calculateUrgency(
                                _urgencyScore), // Store urgency score
                            location: _locationController.text,
                            content: _contentController.text,
                            userid: userId,
                          );
                          addreqpost(post, context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("User ID not found! Please log in.")));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Post'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 2),
    );
  }

  Widget _buildUrgencyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Urgency Details', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        _buildTextField(_urgencyConditionController,
            'Is the patient\'s condition life-threatening? (yes/no)'),
        _buildTextField(_urgencyICUController,
            'Is the patient in ICU or receiving emergency care? (yes/no)'),
        _buildTextField(_urgencyUnstableController,
            'On a scale of 0 to 10, how unstable is the patient\'s condition?'),
        _buildTextField(_urgencyComplicationsController,
            'How many additional critical complications does the patient have?'),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Color _getUrgencyColor(double score) {
    if (score >= 15) {
      return Colors.red.shade900; // Critical (Dark Red)
    } else if (score >= 10) {
      return Colors.red; // High (Red)
    } else if (score >= 6) {
      return Colors.yellow; // Medium (Yellow)
    } else {
      return Colors.white; // Low (White)
    }
  }

  // Function to determine urgency level as text
  String _calculateUrgency(double score) {
    if (score >= 15) {
      return 'Critical';
    } else if (score >= 10) {
      return 'High';
    } else if (score >= 6) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }
}
