import 'package:sanjeevani/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:sanjeevani/functions/navigationbar.dart';

class ContactsPage extends StatefulWidget {
  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: 
           Text(
            'Contacts',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        
        centerTitle: true,
      ),
      body: ListView(
                padding: const EdgeInsets.fromLTRB(16,24,16,24),

        children: [
          ContactItem(
            name: 'Alice Johnson',
            message: 'Hey, how are you?',
            imageUrl: 'assets/con1.jpg',
          ),
          ContactItem(
            name: 'Bob Smith',
            message: 'Can we meet tomorrow?',
            imageUrl: 'assets/con2.jpg',
          ),
          ContactItem(
            name: 'Charlie Brown',
            message: 'Thanks for your help!',
            imageUrl: 'assets/con3.jpg',
          ),
          ContactItem(
            name: 'Diana Prince',
            message: 'Looking forward to it!',
            imageUrl: 'assets/con4.jpg',
          ),
          ContactItem(
            name: 'Eve Adams',
            message: 'Let\'s catch up soon.',
            imageUrl: 'assets/con5.jpg',
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 1,),
    );
  }
}

class ContactItem extends StatefulWidget {
  final String name;
  final String message;
  final String imageUrl;
  ContactItem(
      {required this.name, required this.message, required this.imageUrl});

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(widget.imageUrl),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                widget.message,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
