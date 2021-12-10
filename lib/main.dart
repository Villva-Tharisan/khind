import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khind/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: Home(),
    );
  }
}
