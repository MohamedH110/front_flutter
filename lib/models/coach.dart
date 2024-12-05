class Coach {
  int? id;
  String firstName;
  String lastName;
  int age;
  String email;
  String sport;

  Coach({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    required this.sport,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      age: json['age'],
      email: json['email'],
      sport: json['sport'],
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
    };
  }
}