import 'coach.dart';

class Equipment {
  int? number;
  String name;
  String category;
  double weight;
  bool availability;
  Coach? coach;

  Equipment({
    this.number,
    required this.name,
    required this.category,
    required this.weight,
    required this.availability,
    this.coach,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      number: json['number'],
      name: json['name'],
      category: json['category'],
      weight: json['weight'].toDouble(),
      availability: json['availability'],
      coach: json['coach'] != null ? Coach.fromJson(json['coach']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'category': category,
      'weight': weight,
      'availability': availability,
      'coach': coach?.toJson(),
    };
  }
}