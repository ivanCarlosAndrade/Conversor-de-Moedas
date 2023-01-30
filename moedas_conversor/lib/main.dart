import 'package:flutter/material.dart';
import 'UI/homePage.dart';




void main() async {
  
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      primaryColor: Colors.green,
      hintColor: Colors.green
    ),
  ));
}
