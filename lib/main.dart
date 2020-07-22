import 'package:flutter/material.dart';
import 'package:weatloc/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeatLoc',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Color(0xFF39273E),
      ),
      home: HomePage(title: 'WeatLoc'),
    );
  }
}
