import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _busController = TextEditingController();
  final _parentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Student Name"),
            ),
            TextField(
              controller: _classController,
              decoration: const InputDecoration(labelText: "Class"),
            ),
            TextField(
              controller: _busController,
              decoration: const InputDecoration(labelText: "Bus ID"),
            ),
            TextField(
              controller: _parentController,
              decoration: const InputDecoration(labelText: "Parent ID"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  await firestoreService.addStudent(
                    studentId: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _nameController.text.trim(),
                    className: _classController.text.trim(),
                    busId: _busController.text.trim(),
                    parentId: _parentController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Student Added Successfully"),
                    ),
                  );

                  _nameController.clear();
                  _classController.clear();
                  _busController.clear();
                  _parentController.clear();
                },
              child: const Text("Save Student"),
            ),
          ],
        ),
      ),
    );
  }
}