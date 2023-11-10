import 'package:flutter/material.dart';
import 'package:local_emplyeeapp/SampleApiPage.dart';
import 'UserData.dart';
import 'database_helper.dart';

class EditUserScreen extends StatefulWidget {
  final UserData user;

  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text fields with the user's data
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    emailController.text = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: () async {

                String updatedFirstName = firstNameController.text;
                String updatedLastName = lastNameController.text;
                String updatedEmail = emailController.text;

                // Update the user object with the edited data
                UserData updatedUser = UserData(
                  id: widget.user.id,
                  firstName: updatedFirstName,
                  lastName: updatedLastName,
                  email: updatedEmail,
                  avatar: widget.user.avatar,
                );

                final dbHelper = DatabaseHelper();
                await dbHelper.updateUser(updatedUser); // Update the user in the database

                // Return the edited user to the previous screen
                Navigator.pop(context, updatedUser);
                // ignore: unused_local_variable
                final usersFromDb = await dbHelper.getUsers();


                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SampleApiPage()),
                );


                print("User updated: ${updatedUser.firstName}");
              },
              child: Text('update'),
            ),
          ],
        ),
      ),
    );
  }
}
