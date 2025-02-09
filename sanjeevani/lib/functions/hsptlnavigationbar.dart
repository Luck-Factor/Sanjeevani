import 'package:sanjeevani/screens/addpost.dart';
import 'package:sanjeevani/screens/chatbot.dart';
import 'package:sanjeevani/screens/chatbot2.dart';
import 'package:sanjeevani/screens/contact.dart';
import 'package:sanjeevani/screens/home.dart';
import 'package:sanjeevani/screens/home_hospitals.dart';
import 'package:sanjeevani/screens/hosprofile.dart';
import 'package:sanjeevani/screens/notifications.dart';
import 'package:sanjeevani/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:sanjeevani/screens/organpostadd.dart';

class HospitalNavBar extends StatefulWidget {
  final int selectedIndex;

  const HospitalNavBar({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  State<HospitalNavBar> createState() => _HospitalNavBarState();
}

class _HospitalNavBarState extends State<HospitalNavBar> {
  void _onItemTapped(BuildContext context, int index) {
    if (index == widget.selectedIndex)
      return; // Prevents reloading the same page

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = HospitalHome();
        break;
      case 1:
        nextScreen = ChatScreen2();
        break;
      case 2:
        nextScreen = OrgansPosts();
        break;
      case 3:
        nextScreen = ProfilePages();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      currentIndex: widget.selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Add Organs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
