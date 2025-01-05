import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost/student_grades_api";

  /// Fetch grades for a given student ID
  static Future<List<dynamic>> fetchGrades(String studentId) async {
    final url = Uri.parse('$baseUrl/grades.php?student_id=$studentId');

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      // Log response for debugging
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // Ensure the response is a List<dynamic>
        if (body is List) {
          return body;
        } else {
          throw Exception(
              "Unexpected response format. Expected a list but got: $body");
        }
      } else {
        throw Exception(
            "Failed to fetch grades: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error during fetchGrades request: $e");
      rethrow; // Re-throw error after logging
    }
  }


  /// Add a new grade for a student
  static Future<void> addGrade(String studentId, String subject,
      String grade) async {
    // Replace localhost with 10.0.2.2 for Android emulator compatibility
    final url = Uri.parse('http://10.0.2.2/student_grades_api/grades.php');

    try {
      // Sending a POST request with the data in JSON format
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "student_id": studentId,
          "subject": subject,
          "grade": grade,
        }),
      );

      // Logging for debugging
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // Check if the response contains a success message
        if (body is Map && body.containsKey("message") &&
            body["message"] == "Grade added successfully") {
          print("Grade added successfully");
        } else {
          throw Exception("Unexpected response format: $body");
        }
      } else {
        // Handle non-200 HTTP status codes
        throw Exception(
            "Failed to add grade: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      // Log and rethrow the error for debugging
      print("Error during addGrade request: $e");
      rethrow;
    }
  }
}
