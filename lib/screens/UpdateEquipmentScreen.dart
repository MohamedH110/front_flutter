import 'package:flutter/material.dart';
import '../models/equipment.dart';
import '../models/coach.dart';
import '../services/equipment_service.dart';
import '../services/coach_service.dart';

class UpdateEquipmentScreen extends StatefulWidget {
  final Equipment equipment;

  const UpdateEquipmentScreen({Key? key, required this.equipment}) : super(key: key);

  @override
  _UpdateEquipmentScreenState createState() => _UpdateEquipmentScreenState();
}

class _UpdateEquipmentScreenState extends State<UpdateEquipmentScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _weightController;

  late bool _availability;
  Coach? _selectedCoach;
  List<Coach> _coaches = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.equipment.name);
    _categoryController = TextEditingController(text: widget.equipment.category);
    _weightController = TextEditingController(text: widget.equipment.weight.toString());
    _availability = widget.equipment.availability;
    _selectedCoach = widget.equipment.coach;
    _fetchCoaches();
  }

  Future<void> _fetchCoaches() async {
    try {
      final coaches = await CoachService.getAllCoaches();
      setState(() {
        _coaches = coaches;
        // Set _selectedCoach to a matching coach object from the list
        _selectedCoach = coaches.firstWhere(
              (coach) => coach.id == widget.equipment.coach?.id,
        );
      });
    } catch (e) {
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
        final updatedEquipment = Equipment(
          number: widget.equipment.number,
          name: _nameController.text,
          category: _categoryController.text,
          availability: _availability,
          weight: double.parse(_weightController.text),
          coach: _selectedCoach,
        );

        await EquipmentService.updateEquipment(updatedEquipment);

        Navigator.pop(context, true); // Return true to indicate successful update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Equipment updated successfully')),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Failed to update equipment: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Equipment'),
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
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Equipment Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter equipment name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Availability'),
                value: _availability,
                onChanged: (bool value) {
                  setState(() {
                    _availability = value;
                  });
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
                child: Text('Update Equipment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}