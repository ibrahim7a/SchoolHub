import 'package:flutter/material.dart';
import 'attendance_screen.dart';

class ClassAttendanceScreen extends StatelessWidget {
  const ClassAttendanceScreen({super.key});

  final List<String> classes = const [
    "Class 1",
    "Class 2",
    "Class 3",
    "Class 4",
    "Class 5",
    "Class 6",
    "Class 7",
    "Class 8",
    "Class 9",
    "Class 10",
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

                print(classes[index]);

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