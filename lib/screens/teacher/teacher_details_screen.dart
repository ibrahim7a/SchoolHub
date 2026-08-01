import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherDetailsScreen extends StatelessWidget {
  final String teacherId;

  const TeacherDetailsScreen({
    super.key,
    required this.teacherId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Details"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("teachers")
            .doc(teacherId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.data!.exists) {
            return const Center(
              child: Text("Teacher not found"),
            );
          }

          final teacher = snapshot.data!.data()!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        size: 45,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      teacher["name"],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text("Email"),
                      subtitle: Text(teacher["email"]),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text("Phone"),
                      subtitle: Text(teacher["phone"]),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(Icons.book),
                      title: const Text("Subject"),
                      subtitle: Text(teacher["subject"]),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(Icons.school),
                      title: const Text("Assigned Class"),
                      subtitle: Text(teacher["className"]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}