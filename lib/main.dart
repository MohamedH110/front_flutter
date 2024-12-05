import 'package:flutter/material.dart';
import 'package:projet_tp/screens/equipment_list_screen.dart';

// Import your screens
import 'screens/coach_list_screen.dart';
import 'screens/member_list_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(GymManagementApp());
}

class GymManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      // Start the app with LoginScreen
      home: LoginScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym Management Dashboard'),
        centerTitle: true,
        actions: [
          // Add Logout button to AppBar
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Navigate back to LoginScreen when logout is clicked
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDashboardButton(
              context,
              'Coaches',
              Icons.sports,
              CoachListScreen(),
            ),
            SizedBox(height: 20),
            _buildDashboardButton(
              context,
              'Members',
              Icons.people,
              MemberListScreen(),
            ),
            SizedBox(height: 20),
            _buildDashboardButton(
              context,
              'Equipments',
              Icons.fitness_center,
              EquipmentListScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(
      BuildContext context, String title, IconData icon, Widget destination) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 30),
      label: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(250, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => destination),
        );
      },
    );
  }
}