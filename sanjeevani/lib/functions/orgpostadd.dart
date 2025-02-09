import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sanjeevani/constants/api.dart';
import 'package:sanjeevani/models/orgadd.dart';
import 'package:sanjeevani/screens/home.dart';
import 'package:sanjeevani/screens/home_hospitals.dart';

Future<void> addorgpost(OrgAdd post, BuildContext context) async {
  final organ_name = post.organ_name.trim();
  final blood_type = post.blood_type.trim();
  final hla_markers = post.hla_markers.trim();
  final condition = post.condition.trim();
  final double latitude = post.latitude;
  final double longitude = post.longitude;
  final int hospital_id = post.hospital_id;

  if ([organ_name, blood_type, hla_markers, condition].contains('')) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all the fields')),
    );
    return;
  }

  try {
    final response = await http.post(
      Uri.parse(apiUrl + "/add_organ"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "organ_name": organ_name,
        "blood_type": blood_type,
        "hla_markers": hla_markers,
        "condition": condition,
        "latitude": latitude,
        "longitude": longitude,
        "hospital_id": hospital_id,
      }),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 202) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(responseBody['message'] ?? 'Post Added Successfully!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HospitalHome()),
      );
    } else {
      if (responseBody is List) {
        // Handle list responses (unexpected format)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseBody.isNotEmpty
                  ? responseBody[0].toString()
                  : 'Failed to upload')),
        );
      } else if (responseBody is Map && responseBody.containsKey('detail')) {
        // Handle expected error response with 'detail' key
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['detail'])),
        );
      } else {
        // Handle any other unexpected error format
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to upload: Unexpected response format')),
        );
      }
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $error')),
    );
  }
}
