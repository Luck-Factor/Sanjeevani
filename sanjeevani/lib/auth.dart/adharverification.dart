import 'dart:convert';
import 'dart:io';
import 'package:sanjeevani/screens/login.dart';
import 'package:sanjeevani/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:sanjeevani/models/user.dart';
import 'package:flutter/material.dart';

Future<void> checkAadhar(File img1, BuildContext context) async {
  var url = Uri.parse("https://aadhar-g8ji.onrender.com/extract-aadhar");
  var request = http.MultipartRequest("POST", url);

  // Attach the file
  request.files.add(await http.MultipartFile.fromPath("image", img1.path));

  try {
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var result = jsonDecode(responseData);

    if (response.statusCode == 200 && result["valid"].contains("Valid")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Verification Successful! Extracted Aadhar No.: ${result["aadharNumber"]}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["error"] ?? 'Verification failed')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: Failed to verify Aadhar")),
    );
  }
}



Future<void> verify(File img1, File img2, BuildContext context) async {
  var request = http.MultipartRequest(
    "POST",
    Uri.parse(apiUrl + "/compare-faces/"),
  );

  request.files.add(await http.MultipartFile.fromPath("file1", img1.path));
  request.files.add(await http.MultipartFile.fromPath("file2", img2.path));
  request.fields['threshold'] = "0.5"; // Optional threshold value

  try {
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var result = jsonDecode(responseData);

    if (response.statusCode == 202 && result["match"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification Successful!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["error"] ?? 'Verification failed')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $error')),
    );
  }
}
