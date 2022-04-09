import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainscreen ";

  @override
  State<MainScreen> createState() => _MainSccreenState();
}

class _MainSccreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rider App"),
        backgroundColor: Colors.purple,
      ),
      body: Center(child: Text("Welcome")),
    );
  }
}
