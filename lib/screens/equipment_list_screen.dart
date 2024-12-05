import 'package:flutter/material.dart';
import '../models/equipment.dart';
import '../services/equipment_service.dart';
import 'AddEquipmentScreen.dart';
import 'UpdateEquipmentScreen.dart';

class EquipmentListScreen extends StatefulWidget {
  @override
  _EquipmentListScreenState createState() => _EquipmentListScreenState();
}

class _EquipmentListScreenState extends State<EquipmentListScreen> {
  List<Equipment> _equipmentList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchEquipment();
  }

  Future<void> _fetchEquipment() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      final equipment = await EquipmentService.getAllEquipment();
      setState(() {
        _equipmentList = equipment;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load equipment: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _navigateToAddEquipment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEquipmentScreen()),
    );

    if (result == true) {
      _fetchEquipment();
    }
  }

  void _navigateToUpdateEquipment(Equipment equipment) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateEquipmentScreen(equipment: equipment),
      ),
    );

    if (result == true) {
      _fetchEquipment();
    }
  }

  Future<void> _deleteEquipment(int? id) async {
    if (id == null) return;

    try {
      await EquipmentService.deleteEquipment(id);
      setState(() {
        _equipmentList.removeWhere((equipment) => equipment.number == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Equipment deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete equipment: ${e.toString()}')),
      );
    }
  }

  void _showDeleteConfirmation(int? id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this equipment?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteEquipment(id);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchEquipment,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : _equipmentList.isEmpty
          ? Center(child: Text('No equipment found'))
          : ListView.builder(
        itemCount: _equipmentList.length,
        itemBuilder: (context, index) {
          final equipment = _equipmentList[index];
          return ListTile(
            title: Text(equipment.name),
            subtitle: Text(
              'Category: ${equipment.category}\n'
                  'Weight: ${equipment.weight} kg\n'
                  'Coach: ${equipment.coach != null ? '${equipment.coach!.firstName} ${equipment.coach!.lastName}' : 'No Coach'}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _navigateToUpdateEquipment(equipment),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(equipment.number),
                ),
              ],
            ),
            leading: Icon(
              equipment.availability ? Icons.check_circle : Icons.block,
              color: equipment.availability ? Colors.green : Colors.red,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _navigateToAddEquipment,
      ),
    );
  }
}
