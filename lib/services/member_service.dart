import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/member.dart';

class MemberService {
  static const String baseUrl  = 'http://192.168.56.1:8087';

  static Future<List<Member>> getAllMembers() async {
    final response = await http.get(Uri.parse('$baseUrl/members/all'));
    if (response.statusCode == 200) {
      List<dynamic> membersJson = json.decode(response.body);
      return membersJson.map((json) => Member.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load members');
    }
  }

  static Future<Member> addMember(Member member) async {
    final response = await http.post(
      Uri.parse('$baseUrl/members/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(member.toJson()),
    );
    if (response.statusCode == 200) {
      return Member.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add member');
    }
  }
  static Future<void> deleteMember(int id) async {
    final response = await http.delete(
        Uri.parse('$baseUrl/members/delete/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete coach');
    }
  }

  static Future<Member> updateMember(Member member) async {
    if (member.id == null) {
      throw Exception('Member ID is required for update');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/members/update/${member.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(member.toJson()),
    );

    if (response.statusCode == 200) {
      return Member.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update member');
    }
  }
}
