import 'package:flutter/material.dart';

class BusManagement extends StatelessWidget {
  const BusManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Management"),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Next Step: Add Bus Screen
        },
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text(
          "No Buses Added",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}