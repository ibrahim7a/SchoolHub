import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import 'add_student_screen.dart';

class StudentDetailsScreen extends StatefulWidget {
  final String studentId;

  const StudentDetailsScreen({
    super.key,
    required this.studentId,
  });

  @override
  State<StudentDetailsScreen> createState() =>
      _StudentDetailsScreenState();
}

class _StudentDetailsScreenState
    extends State<StudentDetailsScreen> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Details"),
        backgroundColor: Colors.blue,
      ),

      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("students")
            .doc(widget.studentId)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.data!.exists) {
            return const Center(
              child: Text("Student not found"),
            );
          }

          final student = snapshot.data!.data()!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [

                        const CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            size: 45,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          student["name"] ?? "",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        ListTile(
                          leading: const Icon(Icons.school),
                          title: const Text("Class"),
                          subtitle: Text(
                            student["className"] ?? "",
                          ),
                        ),

                        const Divider(),

                        ListTile(
                          leading: const Icon(Icons.directions_bus),
                          title: const Text("Bus"),
                          subtitle: Text(
                            student["busId"] ?? "",
                          ),
                        ),

                        const Divider(),

                        StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("parents")
                              .doc(student["parentId"])
                              .snapshots(),

                          builder: (context, parentSnapshot) {

                            if (!parentSnapshot.hasData ||
                                !parentSnapshot.data!.exists) {
                              return const SizedBox();
                            }

                            final parent =
                            parentSnapshot.data!.data()!;

                            return Column(
                              children: [

                                ListTile(
                                  leading: const Icon(Icons.family_restroom),
                                  title: const Text("Parent"),
                                  subtitle: Text(parent["name"] ?? ""),
                                ),

                                const Divider(),

                                ListTile(
                                  leading: const Icon(Icons.phone),
                                  title: const Text("Phone"),
                                  subtitle: Text(parent["phone"] ?? ""),
                                ),

                                const Divider(),

                                ListTile(
                                  leading: const Icon(Icons.email),
                                  title: const Text("Email"),
                                  subtitle: Text(parent["email"] ?? ""),
                                ),

                                const Divider(),

                                ListTile(
                                  leading: const Icon(Icons.home),
                                  title: const Text("Address"),
                                  subtitle: Text(parent["address"] ?? ""),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit Student"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddStudentScreen(
                                    studentId: widget.studentId,
                                    studentData: student,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(Icons.delete),
                            label: const Text("Delete Student"),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Student"),
                                    content: const Text(
                                      "Are you sure you want to delete this student?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {
                                await firestoreService
                                    .deleteStudent(widget.studentId);

                                if (!mounted) return;

                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Student deleted successfully",
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}