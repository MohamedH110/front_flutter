import 'package:flutter/material.dart';
import '../models/coach.dart';
import '../services/coach_service.dart';

class UpdateCoachScreen extends StatefulWidget {
  final Coach coach;

  const UpdateCoachScreen({Key? key, required this.coach}) : super(key: key);

  @override
  _UpdateCoachScreenState createState() => _UpdateCoachScreenState();
}

class _UpdateCoachScreenState extends State<UpdateCoachScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _ageController;
  late TextEditingController _emailController;

  // Sports dropdown
  final List<String> _sports = [
    'Football', 'Basketball', 'Swimming', 'Tennis',
    'Yoga', 'Weightlifting', 'Cardio', 'Boxing'
  ];
  String? _selectedSport;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing coach data
    _firstNameController = TextEditingController(text: widget.coach.firstName);
    _lastNameController = TextEditingController(text: widget.coach.lastName);
    _ageController = TextEditingController(text: widget.coach.age.toString());
    _emailController = TextEditingController(text: widget.coach.email);
    _selectedSport = widget.coach.sport;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create an updated Coach object
        final updatedCoach = Coach(
          id: widget.coach.id, // Preserve the original ID
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          age: int.parse(_ageController.text),
          email: _emailController.text,
          sport: _selectedSport!,
        );

        // Call the service to update the coach
        final returnedCoach = await CoachService.updateCoach(updatedCoach);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Coach updated successfully!')),
        );

        // Navigate back and pass the updated coach
        Navigator.of(context).pop(returnedCoach);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update coach: ${e.toString()}')),
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
        title: Text('Update Coach'),
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
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.parse(value) < 18 || int.parse(value) > 70) {
                    return 'Age must be between 18 and 70';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
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
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Sport',
                  border: OutlineInputBorder(),
                ),
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
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Update Coach', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}