import 'dart:convert';
import 'package:sanjeevani/screens/home.dart';
import 'package:sanjeevani/screens/login.dart';
import 'package:sanjeevani/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:sanjeevani/models/donpostadd.dart';
import 'package:sanjeevani/models/reqpostadd.dart';
import 'package:sanjeevani/models/user.dart';
import 'package:flutter/material.dart';

Future<void> adddonpost(AddDonPost post, BuildContext context) async {
  final name = post.name.trim();
  final age = post.age.trim();
  final dontype = post.dontype.trim();
  final gender = post.gender.trim();
  final availability = post.availability.trim();
  final location = post.location.trim();
  final content = post.content.trim();
  final userid = post.userid;

  if ([name, age, dontype, availability, content, location, gender, userid].contains('')) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all the fields')),
    );
    return;
  }

  try {
    final response = await http.post(
      Uri.parse(apiUrl + "/upload_donate"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "age": age,
        "dontype": dontype,
        "gender": gender,
        "availability": availability,
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
