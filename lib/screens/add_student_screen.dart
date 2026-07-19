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
  String? selectedParentId;
  String? selectedParentName;

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

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getClasses(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final classes = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  value: selectedClass,
                  decoration: const InputDecoration(
                    labelText: "Select Class",
                    border: OutlineInputBorder(),
                  ),
                  items: classes.map((doc) {
                    final className =
                        "${doc["className"]} ${doc["section"]}";

                    return DropdownMenuItem(
                      value: className,
                      child: Text(className),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedClass = value;
                    });
                  },
                );
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

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getParentsDropdown(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final parents = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  value: selectedParentId,
                  decoration: const InputDecoration(
                    labelText: "Select Parent",
                    border: OutlineInputBorder(),
                  ),
                  items: parents.map((parent) {
                    return DropdownMenuItem(
                      value: parent.id, // Firebase UID
                      child: Text(parent["name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedParentId = value;
                    });
                  },
                );
              },
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
                      selectedParentId == null) {
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
                    parentId: selectedParentId!,
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