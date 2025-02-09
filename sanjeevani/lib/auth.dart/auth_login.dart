import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanjeevani/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sanjeevani/screens/home.dart';
import 'package:sanjeevani/screens/splash.dart';
import 'package:sanjeevani/models/login.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> logIn(Login user, BuildContext context) async {
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
      Uri.parse(apiUrl + "/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 202) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final access_token = responseData["access token"];
      final userId = responseData["user_id"];
      final email = responseData["email"];
      final pname = responseData["name"];
      final age = responseData["age"];
      final gender = responseData["gender"];
      final city = responseData["city"];
      final phone = responseData["phone"];

      // Store the access token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', access_token);
      await prefs.setInt('user_id', userId);
      await prefs.setString('email', email);
      await prefs.setString('pname', pname);
      await prefs.setString('age', age);
      await prefs.setString('gender', gender);
      await prefs.setString('city', city);
      await prefs.setString('phone', phone);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful!')),
      );
      print(access_token);
      print(userId);

      // Navigate to the next screen (DonationStoriesPage)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MatchedHospitalsScreen()),
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
