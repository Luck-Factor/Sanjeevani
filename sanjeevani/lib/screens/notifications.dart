import 'package:sanjeevani/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:sanjeevani/functions/navigationbar.dart';

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
                padding: const EdgeInsets.fromLTRB(16,24,16,24),

        child: SingleChildScrollView(
          child: Column(
            children: [
              NotificationItem(
                imageUrl: 'assets/not1.jpg',
                title: 'Urgent Blood Request',
                subtitle: 'A+ blood needed at City Hospital',
              ),
              NotificationItem(
                imageUrl: 'assets/not2.jpg',
                title: 'Organ Donation Drive',
                subtitle: 'Join us for a community event',
              ),
              NotificationItem(
                imageUrl: 'assets/not3.jpg',
                title: 'New Message',
                subtitle: 'You have a new message from John',
              ),
              NotificationItem(
                imageUrl: 'assets/not4.jpg',
                title: 'Donation Reminder',
                subtitle: 'Your scheduled donation is tomorrow',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 3),
    );
  }
}

class NotificationItem extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  NotificationItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                widget.subtitle,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
