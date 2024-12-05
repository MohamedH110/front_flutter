import 'package:flutter/material.dart';
import '../models/coach.dart';
import '../services/coach_service.dart';
import 'AddCoachScreen.dart';
import 'UpdateCoachScreen.dart';

class CoachListScreen extends StatefulWidget {
  @override
  _CoachListScreenState createState() => _CoachListScreenState();
}

class _CoachListScreenState extends State<CoachListScreen> {
  List<Coach> coaches = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCoaches();
  }

  Future<void> _fetchCoaches() async {
    try {
      setState(() {
        isLoading = true;
      });
      final fetchedCoaches = await CoachService.getAllCoaches();
      setState(() {
        coaches = fetchedCoaches;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load coaches: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _deleteCoach(int coachId) async {
    try {
      await CoachService.deleteCoach(coachId);
      _fetchCoaches();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete coach: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coaches'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchCoaches,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        itemCount: coaches.length,
        itemBuilder: (context, index) {
          final coach = coaches[index];
          return ListTile(
            title: Text('${coach.firstName} ${coach.lastName}'),
            subtitle: Text('Sport: ${coach.sport}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateCoachScreen(coach: coach), // Pass the specific coach
                      ),
                    ).then((updatedCoach) {
                      if (updatedCoach != null) {
                        // Optionally refresh the list or update the UI
                        _fetchCoaches(); // Assuming you have a method to fetch coaches
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(coach),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddCoachScreen(),
              ),
            ).then((addedCoach) {
              if (addedCoach != null) {
                // Optionally refresh the list of coaches or update the UI
                _fetchCoaches(); // Assuming you have a method to fetch coaches
              }
            });
          }
      ),
    );
  }

  void _showDeleteConfirmation(Coach coach) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Coach'),
        content: Text('Are you sure you want to delete ${coach.firstName} ${coach.lastName}?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
              _deleteCoach(coach.id!);
            },
          ),
        ],
      ),
    );
  }
}