import 'package:flutter/material.dart';
import 'package:sanjeevani/functions/hsptlnavigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePages extends StatefulWidget {
  @override
  State<ProfilePages> createState() => _ProfilePageStates();
}

class _ProfilePageStates extends State<ProfilePages> {
  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<String?> getCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('city');
  }

  Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Hospital Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image at the Center
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                  child: Image.asset(
                    'assets/profile.jpg', // Use Image.asset for local images
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Hospital Name
              FutureBuilder<String?>(
                future: getName(),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? 'Hospital Name',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  );
                },
              ),
              SizedBox(height: 16),

              // Location
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.grey),
                  SizedBox(width: 8),
                  FutureBuilder<String?>(
                    future: getCity(),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? 'Location not available',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Phone Number
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.grey),
                  SizedBox(width: 8),
                  FutureBuilder<String?>(
                    future: getPhone(),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? 'Phone not available',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Email
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, color: Colors.grey),
                  SizedBox(width: 8),
                  FutureBuilder<String?>(
                    future: getEmail(),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? 'Email not available',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HospitalNavBar(selectedIndex: 3),
    );
  }
}
