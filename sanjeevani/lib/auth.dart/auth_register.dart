import 'dart:convert';
import 'package:sanjeevani/screens/home.dart';
import 'package:sanjeevani/screens/home_hospitals.dart';
import 'package:sanjeevani/screens/login.dart';
import 'package:sanjeevani/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:sanjeevani/models/hospital.dart';
import 'package:sanjeevani/models/user.dart';
import 'package:flutter/material.dart';
import 'package:sanjeevani/screens/login_hospital.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> register(Hospital user, BuildContext context) async {
  final name = user.name.trim();

  final city = user.city.trim();
  final email = user.email.trim();
  final phone = user.phone.trim();
  final password = user.password.trim();

  if ([name, city, phone, email, password].contains('')) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all the fields')),
    );
    return;
  }

  try {
    final response = await http.post(
      Uri.parse(apiUrl + "/hospital_register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "city": city,
        "phone": phone,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      final hospital_id = responseData["id"];

      await prefs.setInt('hospital_id', hospital_id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registeration Successfull!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Hospitallogin()),
      );
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['detail'] ?? 'Registeration failed')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $error')),
    );
  }
}
