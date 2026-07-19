import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/firestore_service.dart';
import '../attendance_screen.dart';

class TeacherAttendanceScreen extends StatelessWidget {
  TeacherAttendanceScreen({super.key});

  final firestoreService = FirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Class Attendance"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: firestoreService.getTeacher(currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final teacher = snapshot.data!.data();

          if (teacher == null) {
            return const Center(
              child: Text("Teacher not found"),
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => AttendanceScreen(
                  className: teacher["className"],
                ),
              ),
            );
          });

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}