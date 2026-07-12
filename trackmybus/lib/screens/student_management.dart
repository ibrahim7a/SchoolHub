import 'package:flutter/material.dart';

class StudentManagement extends StatelessWidget {
  const StudentManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Management"),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text("Ahmed Khan"),
            subtitle: Text("Class 5 - Roll No: 12"),
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text("Ayesha Fatima"),
            subtitle: Text("Class 8 - Roll No: 07"),
          ),
          Divider(),
        ],
      ),
    );
  }
}