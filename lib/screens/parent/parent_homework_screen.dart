import 'package:flutter/material.dart';

class ParentHomeworkScreen extends StatelessWidget {
  const ParentHomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homework"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.book, color: Colors.blue),
              title: Text("Mathematics"),
              subtitle: Text("Complete Exercise 5.2"),
              trailing: Text("20 Jul"),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.science, color: Colors.green),
              title: Text("Science"),
              subtitle: Text("Read Chapter 3"),
              trailing: Text("21 Jul"),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.menu_book, color: Colors.orange),
              title: Text("English"),
              subtitle: Text("Learn Poem"),
              trailing: Text("22 Jul"),
            ),
          ),
        ],
      ),
    );
  }
}