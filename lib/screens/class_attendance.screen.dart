import 'package:flutter/material.dart';
import 'attendance_screen.dart';

class ClassAttendanceScreen extends StatelessWidget {
  const ClassAttendanceScreen({super.key});

  final List<String> classes = const [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Class"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.school),
              ),
              title: Text(
                classes[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: const Text("Tap to take attendance"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AttendanceScreen(
                      className: classes[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}