import 'package:flutter/material.dart';
import 'package:sanjeevani/screens/splash.dart';

void main() {
  runApp(MyApp()); // ✅ Corrected runApp call
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
