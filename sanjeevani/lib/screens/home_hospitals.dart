import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanjeevani/functions/organslist.dart';
import 'package:sanjeevani/screens/searchscreen.dart';
import 'package:sanjeevani/functions/showallreqpost.dart';
import 'package:sanjeevani/functions/hsptlnavigationbar.dart';
import 'package:sanjeevani/functions/navigationbar.dart';

class HospitalHome extends StatefulWidget {
  @override
  State<HospitalHome> createState() => _HospitalHomeState();
}

class _HospitalHomeState extends State<HospitalHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Your Inventory',
          style: GoogleFonts.nunito(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7, 
              child: OrganListScreen(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HospitalNavBar(selectedIndex: 0),
    );
  }
}
