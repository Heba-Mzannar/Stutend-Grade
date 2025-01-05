import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/admin_screen.dart';

void main() {
  runApp(StudentGradesApp());
}

class StudentGradesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Student Grades App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      routes: {
        '/admin': (context) => AdminScreen(),
      },
    );
  }
}
