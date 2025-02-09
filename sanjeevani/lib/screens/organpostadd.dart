import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanjeevani/functions/adddonpostfun.dart';
import 'package:sanjeevani/functions/addreqpostfun.dart';
import 'package:sanjeevani/functions/hsptlnavigationbar.dart';
// import 'package:sanjeevani/adddonationpostfun.dart';
import 'package:sanjeevani/models/donpostadd.dart';
import 'package:sanjeevani/models/orgadd.dart';
import 'package:sanjeevani/models/reqpostadd.dart';
// import 'package:sanjeevani/models/donationpostadd.dart';
import 'dart:io';
import 'package:sanjeevani/functions/navigationbar.dart';
import 'package:sanjeevani/functions/orgpostadd.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgansPosts extends StatefulWidget {
  @override
  State<OrgansPosts> createState() => _OrgansPostsState();
}

class _OrgansPostsState extends State<OrgansPosts> {
  var _organ_nameController = TextEditingController();
  var _blood_typeController = TextEditingController();
  var _hla_markersController = TextEditingController();
  var _conditionController = TextEditingController();
  var _latitudeController = TextEditingController();
  var _longitudeController = TextEditingController();

  Future<int?> gethospitalid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('hospital_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          elevation: 0,
          title: Text(
            'Add Organs',
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
                _buildTextField(_organ_nameController, 'Organ Name'),
                SizedBox(height: 10),
                _buildTextField(_blood_typeController, 'Blood Type'),
                SizedBox(height: 10),
                _buildTextField(_hla_markersController, 'Hla Markers'),
                SizedBox(height: 10),
                _buildTextField(_conditionController, 'Condition'),
                SizedBox(height: 20),
                _buildTextField(_latitudeController, 'Latitude'),
                SizedBox(height: 10),
                _buildTextField(_longitudeController, 'Longitude'),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          int? userId = await gethospitalid();
                          if (userId != null) {
                            OrgAdd post = OrgAdd(
                              organ_name: _organ_nameController.text,
                              blood_type: _blood_typeController.text,
                              hla_markers: _hla_markersController.text,
                              condition: _conditionController.text,
                              hospital_id: userId,
                              longitude:
                                  double.tryParse(_longitudeController.text) ??
                                      0.0,
                              latitude:
                                  double.tryParse(_latitudeController.text) ??
                                      0.0,
                            );
                            addorgpost(post, context);
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
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[100],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child:
                            Text('Cancel', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const HospitalNavBar(selectedIndex: 2));
  }
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
