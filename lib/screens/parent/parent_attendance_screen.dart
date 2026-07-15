import 'package:flutter/material.dart';

class ParentAttendanceScreen extends StatelessWidget {
  const ParentAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Column(
                    children: [
                      Text(
                        "22",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text("Present"),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "2",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text("Absent"),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "91%",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text("Attendance"),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text("01 July 2026"),
            trailing: Text("Present"),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text("02 July 2026"),
            trailing: Text("Present"),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.cancel, color: Colors.red),
            title: Text("03 July 2026"),
            trailing: Text("Absent"),
          ),
        ],
      ),
    );
  }
}