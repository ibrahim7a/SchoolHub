import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firestore_service.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({
    super.key,
  });

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState
    extends State<TeacherAttendanceScreen> {

  final FirestoreService firestoreService =
  FirestoreService();

  final User? currentUser =
      FirebaseAuth.instance.currentUser;

  final Map<String, bool> attendance = {};

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Attendance"),
        ),
        body: Center(
          child: Text("Teacher account not found"),
        ),
      );
    }

    return FutureBuilder<
        DocumentSnapshot<Map<String, dynamic>>>(
      future: firestoreService.getTeacher(
        currentUser!.uid,
      ),
      builder: (context, teacherSnapshot) {

        // ==============================
        // LOADING TEACHER
        // ==============================

        if (teacherSnapshot.connectionState ==
            ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Attendance"),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // ==============================
        // ERROR
        // ==============================

        if (teacherSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Attendance"),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Text(
                "Error: ${teacherSnapshot.error}",
              ),
            ),
          );
        }

        // ==============================
        // TEACHER NOT FOUND
        // ==============================

        if (!teacherSnapshot.hasData ||
            !teacherSnapshot.data!.exists ||
            teacherSnapshot.data!.data() == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Attendance"),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            body: const Center(
              child: Text(
                "Teacher data not found",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        // ==============================
        // TEACHER DATA
        // ==============================

        final teacher =
        teacherSnapshot.data!.data()!;

        final String className =
            teacher["className"]?.toString() ??
                "";

        if (className.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Attendance"),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            body: const Center(
              child: Text(
                "No class assigned to this teacher",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        // ==============================
        // ATTENDANCE PAGE
        // ==============================

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "$className Attendance",
            ),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            centerTitle: true,

            // IMPORTANT:
            // Back button will now work normally.
            automaticallyImplyLeading: true,
          ),

          body: StreamBuilder<
              QuerySnapshot<Map<String, dynamic>>>(
            stream:
            firestoreService.getStudentsByClass(
              className,
            ),

            builder: (context, snapshot) {

              // ==============================
              // LOADING STUDENTS
              // ==============================

              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // ==============================
              // ERROR
              // ==============================

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                  ),
                );
              }

              // ==============================
              // NO STUDENTS
              // ==============================

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No Students Found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              final students =
                  snapshot.data!.docs;

              // ==============================
              // STUDENT LIST
              // ==============================

              return Column(
                children: [

                  Expanded(
                    child: ListView.builder(
                      padding:
                      const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      itemCount: students.length,
                      itemBuilder:
                          (context, index) {

                        final student =
                        students[index];

                        // Default = Present
                        attendance.putIfAbsent(
                          student.id,
                              () => true,
                        );

                        final bool isPresent =
                            attendance[
                            student.id] ??
                                true;

                        return Card(
                          margin:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          elevation: 3,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                          ),
                          child: ListTile(

                            leading:
                            CircleAvatar(
                              backgroundColor:
                              isPresent
                                  ? Colors.green
                                  : Colors.red,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),

                            title: Text(
                              student["name"]
                                  .toString(),
                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(
                              "Class: ${student["className"]}",
                            ),

                            trailing:
                            Switch(
                              value: isPresent,
                              activeColor:
                              Colors.green,
                              inactiveThumbColor:
                              Colors.red,
                              onChanged:
                                  (value) {
                                setState(() {
                                  attendance[
                                  student.id] =
                                      value;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // ==========================
                  // SAVE BUTTON
                  // ==========================

                  SafeArea(
                    child: Padding(
                      padding:
                      const EdgeInsets.all(
                        16,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child:
                        ElevatedButton.icon(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.blue,
                            foregroundColor:
                            Colors.white,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                12,
                              ),
                            ),
                          ),

                          icon: const Icon(
                            Icons.save,
                          ),

                          label: const Text(
                            "Save Attendance",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          onPressed: () async {

                            // Prevent double clicking
                            final messenger =
                            ScaffoldMessenger
                                .of(context);

                            try {

                              for (final student
                              in students) {

                                await firestoreService
                                    .markAttendance(
                                  studentId:
                                  student.id,

                                  studentName:
                                  student[
                                  "name"],

                                  className:
                                  student[
                                  "className"],

                                  isPresent:
                                  attendance[
                                  student
                                      .id] ??
                                      true,
                                );
                              }

                              if (!mounted) return;

                              messenger
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Attendance Saved Successfully",
                                  ),
                                  backgroundColor:
                                  Colors.green,
                                ),
                              );

                            } catch (e) {

                              if (!mounted) return;

                              messenger
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Failed to save attendance: $e",
                                  ),
                                  backgroundColor:
                                  Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}