import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Organ {
  final String organName;
  final String bloodType;
  final String hlaMarkers;
  final String condition;
  final int hospital_id;
  final double latitude;
  final double longitude;

  Organ({
    required this.organName,
    required this.bloodType,
    required this.hlaMarkers,
    required this.condition,
    required this.hospital_id,
    required this.latitude,
    required this.longitude,
  });

  factory Organ.fromJson(Map<String, dynamic> json) {
    return Organ(
      organName: json['organ_name'],
      bloodType: json['blood_type'],
      hlaMarkers: json['hla_markers'],
      condition: json['condition'],
      hospital_id: json['hospital_id'], // ✅ Fixed typo
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }
}

class OrganListScreen extends StatefulWidget {
  @override
  _OrganListScreenState createState() => _OrganListScreenState();
}

class _OrganListScreenState extends State<OrganListScreen> {
  List<Organ> organList = [];

  @override
  void initState() {
    super.initState();
    fetchOrgans();
  }

  Future<int?> gethsptlid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> fetchOrgans() async {
    int? hspid = await gethsptlid(); // ✅ Await the result

    if (hspid == null) {
      print("Hospital ID not found in SharedPreferences");
      return;
    }

    final response =
        await http.get(Uri.parse("http://127.0.0.1:8000/organs/$hspid"));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        organList = jsonResponse.map((data) => Organ.fromJson(data)).toList();
      });
    } else {
      print("Failed to load organs: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Available Organs")),
      body: organList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: organList.length,
              itemBuilder: (context, index) {
                final organ = organList[index];
                return Card(
                  child: ListTile(
                    title: Text("${organ.organName}"),
                    subtitle: Text(
                        "Blood Type: ${organ.bloodType}\nCondition: ${organ.condition}"),
                  ),
                );
              },
            ),
    );
  }
}
