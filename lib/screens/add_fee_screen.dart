import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFeeScreen extends StatefulWidget {
  const AddFeeScreen({super.key});

  @override
  State<AddFeeScreen> createState() => _AddFeeScreenState();
}

class _AddFeeScreenState extends State<AddFeeScreen> {

  String? selectedStudentId;
  String? selectedStudentName;

  final totalFeeController = TextEditingController();
  final paidFeeController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Fee"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getStudentsForDropdown(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final students = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Select Student",
                  ),
                  value: selectedStudentId,
                  items: students.map((student) {
                    return DropdownMenuItem(
                      value: student.id,
                      child: Text(student['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStudentId = value;

                      final student = students.firstWhere((e) => e.id == value);
                      selectedStudentName = student['name'];
                    });
                  },
                );
              },
            ),

            TextField(
              controller: totalFeeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Total Fee",
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: paidFeeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Paid Fee",
              ),
            ),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await firestoreService.addFee(
                    studentId: selectedStudentId!,
                    studentName: selectedStudentName!,
                    totalFee: double.parse(totalFeeController.text),
                    paidFee: double.parse(paidFeeController.text),
                  );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Fee Added Successfully"),
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Save Fee"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}