import 'package:flutter/material.dart';
import 'package:sanjeevani/functions/navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<String?> getname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pname');
  }

  Future<String?> getage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('age');
  }

  Future<String?> getcity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('city');
  }

  Future<String?> getphone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  Future<String?> getgender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('gender');
  }

  Future<int?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('user_id');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header: Name and Photo at the top right
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Name immediately left of the image
                  FutureBuilder<String?>(
                    future: getname(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Loading state
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Text(
                          snapshot.data ?? 'Name not available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Text('No name available');
                      }
                    },
                  ),
                  SizedBox(width: 16),
                  // Profile picture with increased size
                  CircleAvatar(
                    radius: 40, // Increased size for the profile image
                    backgroundImage: NetworkImage('assets/profile.jpg'),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Information Row: Gender, Phone, and City with even spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Gender
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.accessibility, color: Colors.grey),
                      SizedBox(width: 4),
                      FutureBuilder<String?>(
                        future: getgender(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Loading state
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            return Text(
                              snapshot.data ?? 'Gender not available',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Text('No gender available');
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.calendar_month, color: Colors.grey),
                      SizedBox(width: 4),
                      FutureBuilder<String?>(
                        future: getage(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Loading state
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            return Text(
                              snapshot.data ?? 'Age not available',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Text('Age not available');
                          }
                        },
                      ),
                    ],
                  ),
                  // Phone
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.phone, color: Colors.grey),
                      SizedBox(width: 4),
                      FutureBuilder<String?>(
                        future: getphone(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Loading state
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            return Text(
                              snapshot.data ?? 'Phone not available',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Text('No phone available');
                          }
                        },
                      ),
                    ],
                  ),
                  // City
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_city, color: Colors.black),
                      SizedBox(width: 4),
                      FutureBuilder<String?>(
                        future: getcity(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Loading state
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            return Text(
                              snapshot.data ?? 'City not available',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            );
                          } else {
                            return Text('No city available');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Your Requests',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 3),
    );
  }
}
