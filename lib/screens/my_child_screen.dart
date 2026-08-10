import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/firestore_service.dart';

class MyChildScreen extends StatelessWidget {
  MyChildScreen({super.key});

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("Parent account not found"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Children"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getStudentsByParent(user.uid),
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
                "No children found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final children = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: children.length,
            itemBuilder: (context, index) {
              final document = children[index];
              final child = document.data();

              final studentId = child["studentId"] ?? document.id;
              final name = child["name"] ?? "Unknown";
              final className = child["className"] ?? "Not assigned";
              final busId = child["busId"] ?? "Not assigned";

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 15),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Class: $className\nBus: $busId",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChildDetailsScreen(
                          studentId: studentId,
                          name: name,
                          className: className,
                          busId: busId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChildDetailsScreen extends StatelessWidget {
  final String studentId;
  final String name;
  final String className;
  final String busId;

  const ChildDetailsScreen({
    super.key,
    required this.studentId,
    required this.name,
    required this.className,
    required this.busId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Student ID: $studentId",
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              "Class: $className",
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 8),
            Text(
              "Bus: $busId",
              style: const TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}