import 'package:flutter/material.dart';
import 'package:freshgrownweb/pages/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SignIn(),
        backgroundColor: Colors.white,
      ),
    );
  }
}
