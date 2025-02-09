import 'dart:convert';
import 'package:sanjeevani/screens/home.dart';
import 'package:sanjeevani/screens/login.dart';
import 'package:sanjeevani/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:sanjeevani/models/reqpostadd.dart';
import 'package:sanjeevani/models/user.dart';
import 'package:flutter/material.dart';

Future<void> addreqpost(AddReqPost post, BuildContext context) async {
  final name = post.name.trim();
  final age = post.age.trim();
  final reqtype = post.reqtype.trim();
  final gender = post.gender.trim();
  final urgency = post.urgency.trim();
  final location = post.location.trim();
  final content = post.content.trim();
  final userid = post.userid;

  if ([name, age, reqtype, urgency, content, location, gender, userid].contains('')) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all the fields')),
    );
    return;
  }

  try {
    final response = await http.post(
      Uri.parse(apiUrl + "/upload_request"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "age": age,
        "reqtype": reqtype,
        "gender": gender,
        "urgency": urgency,
        "location": location,
        "content": content,
        "user_id": userid,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post Added')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MatchedHospitalsScreen()),
      );
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['detail'] ?? 'Failed to upload')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $error')),
);
}
}
