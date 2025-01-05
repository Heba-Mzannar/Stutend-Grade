import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  /// Add Grade Function
  void _addGrade() async {
    final studentId = _studentIdController.text.trim();
    final subject = _subjectController.text.trim();
    final grade = _gradeController.text.trim();

    if (studentId.isEmpty || subject.isEmpty || grade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    try {
      // Replace '10.0.2.2' with your local IP or a live server URL
      final url = Uri.parse("http://localhost/student_grades_api/grades.php");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "student_id": studentId,
          "subject": subject,
          "grade": grade,
        }),
      );

      // Handle response
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body is Map && body['message'] == "Grade added successfully") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Grade added successfully")),
          );

          // Clear input fields
          _studentIdController.clear();
          _subjectController.clear();
          _gradeController.clear();
        } else {
          throw Exception("Unexpected response format: $body");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add grade: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Panel")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(
                labelText: "Student ID",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: "Subject",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _gradeController,
              decoration: InputDecoration(
                labelText: "Grade",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addGrade,
              child: Text("Add Grade"),
            ),
          ],
        ),
      ),
    );
  }
}
