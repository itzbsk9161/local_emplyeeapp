import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'EditUserScreen.dart';
import 'UserData.dart';
import 'database_helper.dart';

class SampleApiPage extends StatefulWidget {
  @override
  _SampleApiPageState createState() => _SampleApiPageState();
}

class _SampleApiPageState extends State<SampleApiPage> {
  List<UserData> users = [];
  UserData? selectedUser;


  Future<void> fetchUserData() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=1'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> userDataList = data['data'];

      final dbHelper = DatabaseHelper();
      for (final userDataJson in userDataList) {
        final user = UserData.fromJson(userDataJson);
        dbHelper.insertUser(user);
      }

      final usersFromDb = await dbHelper.getUsers();

      setState(() {
        users = usersFromDb;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void showUserDetails(UserData user) {
    setState(() {
      selectedUser = user;
    });
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the edit screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserScreen(user: user),
                          ),
                        ).then((editedUser) {
                          if (editedUser != null) {
                            // Update the user in the list and SQLite database
                          }
                        });
                      },
                      child: Text('Edit'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete User'),
                              content: Text('Are you sure you want to delete this user?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final dbHelper = DatabaseHelper();
                                    await dbHelper.deleteUser(selectedUser!.id); // Delete the user from the database

                                    // Remove the user from the list
                                    setState(() {
                                      users.remove(selectedUser);
                                    });

                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('User deleted successfully'),
                                    ));

                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Delete'),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(selectedUser!.avatar),
                      radius: 50.0,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'First Name: ${selectedUser!.firstName}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Last Name: ${selectedUser!.lastName}',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Email: ${selectedUser!.email}',
                  style: TextStyle(fontSize: 18),
                ),
                // Add more user details here as needed
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: users.map((user) {
            return GestureDetector(
              onTap: () => showUserDetails(user),
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.avatar),
                    ),
                    Text('${user.firstName} ${user.lastName}'),
                    Text(user.email),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
