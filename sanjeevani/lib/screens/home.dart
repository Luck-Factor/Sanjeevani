import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sanjeevani/functions/navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchedHospitalsScreen extends StatefulWidget {
  @override
  _MatchedHospitalsScreenState createState() => _MatchedHospitalsScreenState();
}

class _MatchedHospitalsScreenState extends State<MatchedHospitalsScreen> {
  List<dynamic> matchedHospitals = [];
     int? userId;
  @override
  void initState() {
    super.initState();
    loadUserId();
  }
  Future<void> loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedUserId = prefs.getInt("user_id"); // Fetch userId from SharedPreferences

    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      fetchHospitals(storedUserId);
    }
  }
  Future<void> fetchHospitals(int userId) async {
    final String apiUrl = "http://127.0.0.1:8000/search_donors/$userId";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          matchedHospitals = data["matched_hospitals"];
        });
      } else {
        throw Exception("Failed to load hospitals");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Matched Hospitals"),
        backgroundColor: Colors.red,
      ),
      body: matchedHospitals.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: matchedHospitals.map((hospital) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_hospital, color: Colors.red),
                              SizedBox(width: 10),
                              Text(
                                hospital["name"],
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text("📍 City: ${hospital["city"]}", style: TextStyle(fontSize: 16)),
                          Text("📞 Phone: ${hospital["phone"]}", style: TextStyle(fontSize: 16)),
                          Text("✉ Email: ${hospital["email"]}", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 0),
    );
  }
}
