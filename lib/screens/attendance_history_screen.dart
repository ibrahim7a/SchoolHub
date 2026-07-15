import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance History"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attendance')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Attendance Records",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final attendance = snapshot.data!.docs;

          return ListView.builder(
            itemCount: attendance.length,
            itemBuilder: (context, index) {
              final data =
              attendance[index].data() as Map<String, dynamic>;

              final Timestamp timestamp = data['date'];
              final date =
              DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate());

              final bool present = data['isPresent'];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                    present ? Colors.green : Colors.red,
                    child: Icon(
                      present ? Icons.check : Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(data['studentName']),
                  subtitle: Text(date),
                  trailing: Text(
                    present ? "Present" : "Absent",
                    style: TextStyle(
                      color:
                      present ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}