import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coach.dart';


class CoachService {
  static const String baseUrl = 'http://192.168.56.1:8087';

  static Future<List<Coach>> getAllCoaches() async {
    final response = await http.get(Uri.parse('$baseUrl/coaches/all'));
    if (response.statusCode == 200) {
      List<dynamic> coachesJson = json.decode(response.body);
      return coachesJson.map((json) => Coach.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load coaches');
    }
  }

  static Future<Coach> addCoach(Coach coach) async {
    final response = await http.post(
      Uri.parse('$baseUrl/coaches/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(coach.toJson()),
    );
    if (response.statusCode == 200) {
      return Coach.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add coach');
    }
  }

  static Future<Coach> updateCoach(Coach coach) async {
    final response = await http.put(
      Uri.parse('$baseUrl/coaches/update/${coach.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(coach.toJson()),
    );
    if (response.statusCode == 200) {
      return Coach.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update coach');
    }
  }

  static Future<void> deleteCoach(int id) async {
    final response = await http.delete(
        Uri.parse('$baseUrl/coaches/delete/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete coach');
    }
  }
  }
