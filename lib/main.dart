import 'package:flutter/material.dart';
import 'package:local_emplyeeapp/SampleApiPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Employee',
      home: SampleApiPage(), // Show SampleApiPage directly
    );
  }
} 