import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost/student_grades_api/";

  /// Fetch grades for a given student ID
  static Future<List<dynamic>> fetchGrades(String studentId) async {
    final url = Uri.parse("${baseUrl}grades?student_id=$studentId");

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      // Log response for debugging
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch grades: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error during fetchGrades request: $e");
      rethrow;  // Re-throw error after logging
    }
  }

  /// Add a new grade for a student
  static Future<void> addGrade(String studentId, String subject, String grade) async {
    final url = Uri.parse("${baseUrl}grades");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "student_id": studentId,
          "subject": subject,
          "grade": grade,
        }),
      );

      // Log response for debugging
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("Grade added successfully");
      } else {
        throw Exception("Failed to add grade: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error during addGrade request: $e");
      rethrow;  // Re-throw error after logging
    }
  }
}
