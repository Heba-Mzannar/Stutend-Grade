import 'package:flutter/material.dart';
import 'package:student_grades_app/services/api_service.dart';

class ResultScreen extends StatefulWidget {
  final String studentId;

  ResultScreen({required this.studentId});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Future<List<dynamic>> _gradesFuture;

  @override
  void initState() {
    super.initState();
    _gradesFuture = ApiService.fetchGrades(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Grades for ${widget.studentId}")),
      body: FutureBuilder<List<dynamic>>(
        future: _gradesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("No grades found for this student ID"));
          }

          final grades = snapshot.data!;
          return ListView.builder(
            itemCount: grades.length,
            itemBuilder: (context, index) {
              final grade = grades[index];
              return ListTile(
                title: Text("Subject: ${grade['subject']}"),
                subtitle: Text("Grade: ${grade['grade']}"),
              );
            },
          );
        },
      ),
    );
  }
}
