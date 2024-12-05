import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';


class UserService {
  // Register User API
  static const String baseUrl = "http://192.168.56.1:8087"; // Replace with your Spring Boot server URL
  static const String registerEndpoint = "/register";
  static const String loginEndpoint = "/login";

  static Future<bool> registerUser(String email, String password) async {
    final url = Uri.parse(baseUrl + registerEndpoint);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print('Error during registration: $e');
    }

    return false;
  }

  // Login User API
  static Future<User?> loginUser(String email, String password) async {
    final url = Uri.parse(baseUrl + loginEndpoint);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User(email: email, password: password);
      }
    } catch (e) {
      print('Error during login: $e');
    }

    return null;
  }
}
