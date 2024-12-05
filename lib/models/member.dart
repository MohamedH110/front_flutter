import 'coach.dart';

class Member {
  int? id;
  String firstName;
  String lastName;
  int age;
  String email;
  String sport;
  String password;
  Coach? coach;

  Member({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    required this.sport,
    required this.password,
    this.coach,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      age: json['age'],
      email: json['email'],
      sport: json['sport'],
      password: json['password'],
      coach: json['coach'] != null ? Coach.fromJson(json['coach']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'age': age,
      'email': email,
      'sport': sport,
      'password': password,
      'coach': coach?.toJson(),
    };
  }
}
