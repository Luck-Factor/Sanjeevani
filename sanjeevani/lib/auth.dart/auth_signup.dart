import 'dart:convert';
import 'package:sanjeevani/screens/login.dart';
import 'package:sanjeevani/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:sanjeevani/models/user.dart';
import 'package:flutter/material.dart';

Future<void> signUp(User user, BuildContext context) async {
  final name = user.name.trim();
  final age = user.age.trim();
  final city = user.city.trim();
  final email = user.email.trim();
  final phone = user.phone.trim();
  final password = user.password.trim();
  final gender = user.gender.trim();

  if ([name, age,city, phone, email, password,gender].contains('')) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all the fields')),
    );
    return;
  }

  try {
    final response = await http.post(
      Uri.parse(apiUrl + "/users"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "age": age,
        "city":city,
        "phone": phone,
        "email": email,
        "password": password,
        "gender":gender,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup successful!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['detail'] ?? 'Signup failed')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $error')),
    );
  }
}
