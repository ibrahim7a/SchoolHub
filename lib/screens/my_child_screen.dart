import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackmybus/services/firestore_service.dart';

class MyChildScreen extends StatelessWidget {
  MyChildScreen({super.key});

  final firestoreService = FirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Child"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getStudentsByParent(currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No student assigned to this parent"),
            );
          }

          final studentDoc = snapshot.data!.docs.first;
          final student = studentDoc.data();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Text(
                  student["name"] ?? "Unknown Student",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Student ID : ${studentDoc.id}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Student Details Card
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.class_),
                        title: const Text("Class"),
                        trailing: Text(student["className"] ?? "N/A"),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.confirmation_number),
                        title: const Text("Roll Number"),
                        trailing: Text(student["rollNumber"] ?? "12"),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.directions_bus),
                        title: const Text("Bus Number"),
                        trailing: Text(student["busNumber"] ?? "TS09 AB 1234"),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.water_drop),
                        title: const Text("Blood Group"),
                        trailing: Text(student["bloodGroup"] ?? "O+"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Parent Details Card
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text("Parent Name"),
                        trailing: Text(student["parentName"] ?? "Ibrahim"),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text("Phone"),
                        trailing: Text(student["phone"] ?? "9876543210"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Stats Row (Attendance & Homework summary)
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: const [
                              Icon(Icons.check_circle, color: Colors.green, size: 35),
                              SizedBox(height: 8),
                              Text("Attendance"),
                              Text(
                                "95%",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16), // Fixed: Use width inside a Row
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: const [
                              Icon(Icons.assignment, color: Colors.orange, size: 35),
                              SizedBox(height: 8),
                              Text("Homework"),
                              Text(
                                "3",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Actions GridView (Moved out of Row into the main Column)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildGridItem(Icons.directions_bus, "Track Bus", Colors.blue, () {}),
                    _buildGridItem(Icons.bar_chart, "Results", Colors.green, () {}),
                    _buildGridItem(Icons.notifications, "Notices", Colors.orange, () {}),
                    _buildGridItem(Icons.book, "Homework", Colors.purple, () {}),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Extracted Helper Method to clean up repeated GridView layouts
  Widget _buildGridItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}