import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firestore_service.dart';

class AddHomeworkScreen extends StatefulWidget {
  const AddHomeworkScreen({super.key});

  @override
  State<AddHomeworkScreen> createState() => _AddHomeworkScreenState();
}

class _AddHomeworkScreenState extends State<AddHomeworkScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDateController = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser;

  String? teacherSubject;
  String? teacherClass;

  @override
  void initState() {
    super.initState();
    loadTeacher();
  }

  Future<void> loadTeacher() async {
    final teacherDoc =
    await firestoreService.getTeacher(currentUser!.uid);

    final data = teacherDoc.data();

    if (data != null) {
      setState(() {
        teacherSubject = data["subject"];
        teacherClass = data["className"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (teacherSubject == null || teacherClass == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Homework"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.menu_book,
                  color: Colors.blue,
                ),
                title: Text(
                  "Subject : $teacherSubject",
                ),
                subtitle: Text(
                  "Class : $teacherClass",
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Homework Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: dueDateController,
              decoration: const InputDecoration(
                labelText: "Due Date",
                hintText: "15-07-2026",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (titleController.text.trim().isEmpty ||
                      descriptionController.text.trim().isEmpty ||
                      dueDateController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all fields"),
                      ),
                    );
                    return;
                  }

                  await firestoreService.addHomework(
                    subject: teacherSubject!,
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    dueDate: dueDateController.text.trim(),
                    className: teacherClass!,
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