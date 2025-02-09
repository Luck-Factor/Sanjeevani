import 'package:flutter/material.dart';
import 'package:sanjeevani/auth.dart/auth_signup.dart';
import 'package:sanjeevani/screens/hospitalregister.dart';
import 'package:sanjeevani/screens/singup.dart';

class HospitalUser extends StatefulWidget {
  const HospitalUser({super.key});

  @override
  State<HospitalUser> createState() => _HospitalUserState();
}

class _HospitalUserState extends State<HospitalUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.red.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterHospital()));
              },
              child: Text(
                "Register as Hospital",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.red.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAccountPage()));
              },
              child:
                  Text("SignUp as User", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    ));
  }
}
