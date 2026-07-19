import 'package:flutter/material.dart';

class ParentResultScreen extends StatelessWidget {
  const ParentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Results"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text("Results will appear here"),
      ),
    );
  }
}