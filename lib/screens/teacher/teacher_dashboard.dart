import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import 'teacher_attendance_screen.dart';
import '../homework_screen.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final FirestoreService firestoreService = FirestoreService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: firestoreService.getTeacher(currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              !snapshot.data!.exists ||
              snapshot.data!.data() == null) {
            return const Center(
              child: Text("Teacher data not found"),
            );
          }

          final teacher = snapshot.data!.data()!;

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome ${teacher["name"]}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("Subject : ${teacher["subject"]}"),
                    Text("Class : ${teacher["className"]}"),
                  ],
                ),
              ),

              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(20),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TeacherAttendanceScreen(),
                            ),
                          );
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fact_check,
                              color: Colors.green,
                              size: 45,
                            ),
                            SizedBox(height: 10),
                            Text("Attendance"),
                          ],
                        ),
                      ),
                    ),

                    Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                          MaterialPageRoute(builder: (_) => HomeworkScreen(),
                            ),
                          );
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.menu_book,
                              color: Colors.orange,
                              size: 45,
                            ),
                            SizedBox(height: 10),
                            Text("Homework"),
                          ],
                        ),
                      ),
                    ),

                    Card(
                      child: InkWell(
                        onTap: () {},
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assessment,
                              color: Colors.blue,
                              size: 45,
                            ),
                            SizedBox(height: 10),
                            Text("Results"),
                          ],
                        ),
                      ),
                    ),

                    Card(
                      child: InkWell(
                        onTap: () {},
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications,
                              color: Colors.red,
                              size: 45,
                            ),
                            SizedBox(height: 10),
                            Text("Notices"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}