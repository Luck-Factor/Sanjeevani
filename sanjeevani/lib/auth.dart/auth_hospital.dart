import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanjeevani/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sanjeevani/screens/home.dart';
import 'package:sanjeevani/screens/home_hospitals.dart';
import 'package:sanjeevani/screens/splash.dart';
import 'package:sanjeevani/models/login.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> hospitallog(Login user, BuildContext context) async {
  final name = user.name.trim();
  final email = user.email.trim();
  final password = user.password.trim();

  if ([name, email, password].contains('')) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all the fields')),
    );
    return;
  }

  try {
    final response = await http.post(
      Uri.parse(apiUrl + "/hospital_login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 202) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final access_token = responseData["access_token"];
      final hospitalId = responseData["hospital_id"];
      final hospital_emails = responseData["email"];
      final hospital_name = responseData["name"];
      final hospital_city = responseData["city"];
      final hospital_phone = responseData["phone"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', access_token);
      await prefs.setInt('user_id', hospitalId);
      await prefs.setString('email', hospital_emails);
      await prefs.setString('name', hospital_name);
      await prefs.setString('city', hospital_city);
      await prefs.setString('phone', hospital_phone);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful!')),
      );
      print(access_token);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HospitalHome()),
      );
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['detail'] ?? 'Login failed')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $error')),
    );
  }
}
