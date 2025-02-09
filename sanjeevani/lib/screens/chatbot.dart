import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sanjeevani/screens/home.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanjeevani-AI',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;

  Future<void> sendMessage() async {
    if (_controller.text.isEmpty) return;
    setState(() {
      messages.add({'role': 'user', 'text': _controller.text});
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://f11e-182-74-15-122.ngrok-free.app/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': _controller.text}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        messages.add({'role': 'bot', 'text': responseData['response']});
        isLoading = false;
      });
    } else {
      setState(() {
        messages.add({'role': 'bot', 'text': 'Error: Unable to get response'});
        isLoading = false;
      });
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the Home page when the back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MatchedHospitalsScreen()), // Replace with your HomePage
        );
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sanjeevani AI"),
          backgroundColor: Colors.red,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return Align(
                      alignment: msg['role'] == 'user'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: msg['role'] == 'user'
                              ? Colors.red.shade400
                              : Colors.blueGrey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          msg['text']!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (isLoading) CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration:
                            InputDecoration(hintText: 'Enter your query....'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
