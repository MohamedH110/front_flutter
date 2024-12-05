import 'package:flutter/material.dart';
import 'package:projet_tp/services/coach_service.dart';
import '../models/member.dart';
import '../models/coach.dart';
import '../services/member_service.dart';

class UpdateMemberScreen extends StatefulWidget {
  final Member member;

  const UpdateMemberScreen({Key? key, required this.member}) : super(key: key);

  @override
  _UpdateMemberScreenState createState() => _UpdateMemberScreenState();
}

class _UpdateMemberScreenState extends State<UpdateMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _ageController;
  late TextEditingController _emailController;

  String? _selectedSport;
  Coach? _selectedCoach;
  List<Coach> _coaches = [];
  bool _isLoading = true; // Change initial state to true

  final List<String> _sports = [
    'Football', 'Basketball', 'Swimming', 'Tennis',
    'Yoga', 'Weightlifting', 'Cardio', 'Boxing'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing member data
    _firstNameController = TextEditingController(text: widget.member.firstName);
    _lastNameController = TextEditingController(text: widget.member.lastName);
    _ageController = TextEditingController(text: widget.member.age.toString());
    _emailController = TextEditingController(text: widget.member.email);

    // Set initial values
    _selectedSport = widget.member.sport;

    // Fetch coaches and then set the selected coach
    _fetchCoaches();
  }

  Future<void> _fetchCoaches() async {
    try {
      final coaches = await CoachService.getAllCoaches();
      setState(() {
        _coaches = coaches;
        // Find the matching coach after coaches are loaded
        _selectedCoach = _coaches.firstWhere(
                (coach) => coach.id == widget.member.coach?.id
        );
        _isLoading = false; // Set loading to false after coaches are loaded
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Ensure loading is set to false even if there's an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load coaches: ${e.toString()}')),
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create an updated member object
        final updatedMember = Member(
          id: widget.member.id, // Preserve the original ID
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          age: int.parse(_ageController.text),
          email: _emailController.text,
          sport: _selectedSport!,
          password: widget.member.password, // Preserve the original password
          coach: _selectedCoach,
        );

        // Call update method in API service
        await MemberService.updateMember(updatedMember);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Member updated successfully!')),
        );

        Navigator.of(context).pop(true); // Return true to indicate successful update
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update member: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Member'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sport'),
                value: _selectedSport,
                items: _sports.map((sport) {
                  return DropdownMenuItem(
                    value: sport,
                    child: Text(sport),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSport = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a sport';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Coach>(
                decoration: InputDecoration(labelText: 'Coach'),
                value: _selectedCoach,
                items: _coaches.map((coach) {
                  return DropdownMenuItem(
                    value: coach,
                    child: Text('${coach.firstName} ${coach.lastName} - ${coach.sport}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCoach = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a coach';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Update Member'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}