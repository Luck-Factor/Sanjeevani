import 'package:sanjeevani/screens/addpost.dart';
import 'package:sanjeevani/screens/chatbot.dart';
import 'package:sanjeevani/screens/contact.dart';
import 'package:sanjeevani/screens/home.dart';
import 'package:sanjeevani/screens/notifications.dart';
import 'package:sanjeevani/screens/profile.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _onItemTapped(BuildContext context, int index) {
    if (index == widget.selectedIndex) return; // Prevents reloading the same page

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = MatchedHospitalsScreen();
        break;
      case 1:
        nextScreen = ChatScreen();
        break;
      case 2:
        nextScreen = FormWidget();
        break;
      case 3:
        nextScreen = ProfilePage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextScreen));
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
          label: 'Donate',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
