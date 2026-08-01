import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class AttendanceScreen extends StatefulWidget {
  final String className;

  const AttendanceScreen({
    super.key,
    required this.className,
  });

  @override
  State<AttendanceScreen> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState
    extends State<AttendanceScreen> {

  final FirestoreService firestoreService =
  FirestoreService();

  final Map<String, bool> attendance = {};

  @override
  Widget build(BuildContext context) {

    print("Selected Class = ${widget.className}");

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.className} Attendance"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getStudentsByClass(
          widget.className,
        ),

        builder: (context, snapshot) {

          print("Selected Class = ${widget.className}");

          if (snapshot.hasData) {
            print("Students = ${snapshot.data!.docs.length}");
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Students Found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final students = snapshot.data!.docs;

          return Column(
            children: [

              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {

                    final student = students[index];

                    attendance.putIfAbsent(
                      student.id,
                          () => true,
                    );
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(
                          student["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          "Class : ${student["className"]}",
                        ),

                        trailing: Switch(
                          value: attendance[student.id]!,
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.red,
                          onChanged: (value) {
                            setState(() {
                              attendance[student.id] =
                                  value;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text(
                      "Save Attendance",
                    ),
                    onPressed: () async {
                      for (final student
                      in students) {
                        await firestoreService
                            .markAttendance(
                          studentId: student.id,
                          studentName:
                          student["name"],
                          className: student['className'],
                          isPresent:
                          attendance[student.id] ??
                              true,
                        );
                      }
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Attendance Saved Successfully",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}