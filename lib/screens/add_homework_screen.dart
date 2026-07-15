import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

class AddHomeworkScreen extends StatefulWidget {
  const AddHomeworkScreen({super.key});

  @override
  State<AddHomeworkScreen> createState() => _AddHomeworkScreenState();
}

class _AddHomeworkScreenState extends State<AddHomeworkScreen> {
  final subjectController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDateController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Homework"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: "Subject",
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Homework Title",
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: dueDateController,
              decoration: const InputDecoration(
                labelText: "Due Date",
                hintText: "15-07-2026",
              ),
            ),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await firestoreService.addHomework(
                    subject: subjectController.text.trim(),
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    dueDate: dueDateController.text.trim(),
                  );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Homework Added Successfully"),
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Save Homework"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}