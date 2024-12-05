import 'package:flutter/material.dart';
import '../models/member.dart';
import '../services/member_service.dart';
import 'AddMemberScreen.dart';
import 'UpdateMemberScreen.dart';

class MemberListScreen extends StatefulWidget {
  @override
  _MemberListScreenState createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  List<Member> members = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    try {
      setState(() {
        isLoading = true;
      });
      final fetchedMembers = await MemberService.getAllMembers();
      setState(() {
        members = fetchedMembers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load members: ${e.toString()}';
        isLoading = false;
      });
    }
  }
  void _deleteMember(int id) async {
    try {
      await MemberService.deleteMember(id);
      _fetchMembers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete member: ${e.toString()}')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchMembers,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return ListTile(
            title: Text('${member.firstName} ${member.lastName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Age: ${member.age}'),
                Text('Sport: ${member.sport}'),
                if (member.coach != null)
                  Text('Coach: ${member.coach!.firstName} ${member.coach!.lastName}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    // Navigate to the update screen and wait for result
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdateMemberScreen(member: member),
                      ),
                    );

                    // If update was successful, refresh the list
                    if (result == true) {
                      _fetchMembers();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(member),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddMemberScreen()),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(Member member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Member'),
        content: Text('Are you sure you want to delete ${member.firstName} ${member.lastName}?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // TODO: Implement member deletion
              Navigator.of(context).pop();
              _deleteMember(member.id!);
            },
          ),
        ],
      ),
    );
  }
}