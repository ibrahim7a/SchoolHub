import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final _nameController = TextEditingController();
  final _parentController = TextEditingController();

  String? selectedClass;
  String? selectedBusId;

  final List<String> classes = const [
    "Class 1A",
    "Class 1B",
    "Class 2A",
    "Class 2B",
    "Class 3A",
    "Class 3B",
    "Class 4A",
    "Class 4B",
    "Class 5A",
    "Class 5B",
    "Class 6A",
    "Class 6B",
    "Class 7A",
    "Class 7B",
    "Class 8A",
    "Class 8B",
    "Class 9A",
    "Class 9B",
    "Class 10A",
    "Class 10B",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Student Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedClass,
              decoration: const InputDecoration(
                labelText: "Select Class",
                border: OutlineInputBorder(),
              ),
              items: classes.map((className) {
                return DropdownMenuItem<String>(
                  value: className,
                  child: Text(className),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                });
              },
            ),

            const SizedBox(height: 15),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getBusDropdown(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final buses = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  value: selectedBusId,
                  decoration: const InputDecoration(
                    labelText: "Select Bus",
                    border: OutlineInputBorder(),
                  ),
                  items: buses.map((bus) {
                    return DropdownMenuItem<String>(
                      value: bus.id,
                      child: Text(bus["busNumber"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBusId = value;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: _parentController,
              decoration: const InputDecoration(
                labelText: "Parent ID",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: const Text("Save Student"),
                onPressed: () async {
                  if (_nameController.text.trim().isEmpty ||
                      selectedClass == null ||
                      selectedBusId == null ||
                      _parentController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all fields"),
                      ),
                    );
                    return;
                  }

                  await firestoreService.addStudent(
                    studentId:
                    DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _nameController.text.trim(),
                    className: selectedClass!,
                    busId: selectedBusId!,
                    parentId: _parentController.text.trim(),
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Student Added Successfully"),
                    ),
                  );

                  _nameController.clear();
                  _parentController.clear();

                  setState(() {
                    selectedClass = null;
                    selectedBusId = null;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}