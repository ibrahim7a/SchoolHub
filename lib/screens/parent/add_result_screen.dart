import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackmybus/services/firestore_service.dart';

class AddResultScreen extends StatefulWidget {
  const AddResultScreen({super.key});

  @override
  State<AddResultScreen> createState() => _AddResultScreenState();
}

class _AddResultScreenState extends State<AddResultScreen> {

  final studentController = TextEditingController();
  final subjectController = TextEditingController();
  final marksController = TextEditingController();
  final totalController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();
  String? selectedClass;
  String? selectedStudentId;
  String? selectedStudentName;
  String? selectedSubject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Result"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedSubject,
              decoration: const InputDecoration(
                labelText: "Select Subject",
                border: OutlineInputBorder(),
              ),
              items: const [
                "English",
                "Urdu",
                "Hindi",
                "Mathematics",
                "Science",
                "Social Studies",
                "Computer",
                "GK",
                "Islamic Studies",
              ].map((subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
            ),



            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedClass,
              decoration: const InputDecoration(
                labelText: "Select Class",
                border: OutlineInputBorder(),
              ),
              items: const [
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
              ].map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                  selectedStudentId = null;
                  selectedStudentName = null;
                });
              },
            ),

            if (selectedClass != null)
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: firestoreService.getStudentsByClass(selectedClass!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final students = snapshot.data!.docs;

                  return DropdownButtonFormField<String>(
                    value: selectedStudentId,
                    decoration: const InputDecoration(
                      labelText: "Select Student",
                      border: OutlineInputBorder(),
                    ),
                    items: students.map((student) {
                      return DropdownMenuItem(
                        value: student.id,
                        child: Text(student['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStudentId = value;
                        selectedStudentName = students
                            .firstWhere((e) => e.id == value)['name'];
                      });
                    },
                  );
                },
              ),

            const SizedBox(height: 15),

            TextField(
              controller: marksController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Marks Obtained",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: totalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Total Marks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {

                  if (selectedClass == null ||
                      selectedStudentId == null ||
                      selectedStudentName == null ||
                      selectedSubject == null ||
                      marksController.text.isEmpty ||
                      totalController.text.isEmpty) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all fields"),
                      ),
                    );
                    return;
                  }

                  await firestoreService.addResult(
                    studentId: selectedStudentId!,
                    studentName: selectedStudentName!,
                    className: selectedClass!,
                    subject: selectedSubject!,
                    marks: double.parse(marksController.text),
                    totalMarks: double.parse(totalController.text),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Result Added Successfully"),
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Save Result"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}