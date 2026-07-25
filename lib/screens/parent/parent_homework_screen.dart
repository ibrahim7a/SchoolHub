import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/firestore_service.dart';

class ParentHomeworkScreen extends StatefulWidget {
  const ParentHomeworkScreen({super.key});

  @override
  State<ParentHomeworkScreen> createState() =>
      _ParentHomeworkScreenState();
}

class _ParentHomeworkScreenState
    extends State<ParentHomeworkScreen> {
  final firestoreService = FirestoreService();

  final currentUser = FirebaseAuth.instance.currentUser;

  String? className;

  @override
  void initState() {
    super.initState();
    loadParent();
  }

  Future<void> loadParent() async {
    final parent =
    await firestoreService.getParent(currentUser!.uid);

    final data = parent.data();

    if (data != null) {
      setState(() {
        className = data["className"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (className == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Homework"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getHomeworkByClass(className!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Homework Available",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final homework = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: homework.length,
            itemBuilder: (context, index) {
              final data = homework[index].data();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.book),
                  ),
                  title: Text(data["title"]),
                  subtitle: Text(
                    "${data["subject"]}\n${data["description"]}",
                  ),
                  trailing: Text(data["dueDate"]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}