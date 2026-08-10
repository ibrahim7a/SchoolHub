import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';

class ParentAttendanceScreen extends StatelessWidget {
  final String studentId;
  final String studentName;

  ParentAttendanceScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$studentName Attendance"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getAttendanceByStudent(studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No attendance record found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final records = snapshot.data!.docs;

          int present = 0;
          int absent = 0;

          for (final doc in records) {
            final data = doc.data();

            if (data['isPresent'] == true) {
              present++;
            } else {
              absent++;
            }
          }

          final total = present + absent;
          final percentage =
          total == 0 ? 0 : (present / total) * 100;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "$present",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Text("Present"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "$absent",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const Text("Absent"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "${percentage.toStringAsFixed(0)}%",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const Text("Attendance"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ...records.map((doc) {
                final data = doc.data();

                final isPresent = data['isPresent'] == true;
                final timestamp = data['date'] as Timestamp?;

                String date = "Unknown date";

                if (timestamp != null) {
                  final d = timestamp.toDate();

                  date =
                  "${d.day.toString().padLeft(2, '0')} "
                      "${_month(d.month)} ${d.year}";
                }

                return Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        isPresent
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: isPresent
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text(date),
                      trailing: Text(
                        isPresent ? "Present" : "Absent",
                        style: TextStyle(
                          color: isPresent
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }),
            ],
          );
        },
      ),
    );
  }

  String _month(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return months[month - 1];
  }
}