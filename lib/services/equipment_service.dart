import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/equipment.dart';

class EquipmentService {
  static const String baseUrl = 'http://192.168.56.1:8087';

  static Future<List<Equipment>> getAllEquipment() async {
    final response = await http.get(Uri.parse('$baseUrl/equipments/all'));
    if (response.statusCode == 200) {
      List<dynamic> equipmentJson = json.decode(response.body);
      return equipmentJson.map((json) => Equipment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load equipment');
    }
  }

  static Future<Equipment> addEquipment(Equipment equipment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/equipments/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(equipment.toJson()),
    );
    if (response.statusCode == 200) {
      return Equipment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add equipment');
    }
  }

  static Future<void> deleteEquipment(int number) async {
    final response = await http.delete(
        Uri.parse('$baseUrl/equipments/delete/$number'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete equipment');
    }
  }

  static Future<Equipment> updateEquipment(Equipment equipment) async {
    if (equipment.number == 0) {
      throw Exception('Equipment number is required for update');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/equipments/update/${equipment.number}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(equipment.toJson()),
    );

    if (response.statusCode == 200) {
      return Equipment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update equipment');
    }
  }
}
