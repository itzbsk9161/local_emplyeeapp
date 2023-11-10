import 'package:flutter/material.dart';

class EmployeeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> employee;

  EmployeeDetailsPage({required this.employee});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Employee Details'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Content for Tab 1
            Center(
              child: Text('Tab 1 Content'),
            ),

            // Content for Tab 2
            Center(
              child: Text('Tab 2 Content'),
            ),
          ],
        ),
      ),
    );
  }
}
