import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class ClassManagementScreen extends StatefulWidget {
  const ClassManagementScreen({super.key});

  @override
  State<ClassManagementScreen> createState() =>
      _ClassManagementScreenState();
}

class _ClassManagementScreenState
    extends State<ClassManagementScreen> {

  final FirestoreService firestoreService = FirestoreService();

  final classController = TextEditingController();
  final sectionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Management"),
        backgroundColor: Colors.blue,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Add Class"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: classController,
                    decoration: const InputDecoration(
                      labelText: "Class Name",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: sectionController,
                    decoration: const InputDecoration(
                      labelText: "Section",
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await firestoreService.addClass(
                      className: classController.text.trim(),
                      section: sectionController.text.trim(),
                    );

                    classController.clear();
                    sectionController.clear();

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          );
        },
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getClasses(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final classes = snapshot.data!.docs;

          if (classes.isEmpty) {
            return const Center(
              child: Text("No Classes Found"),
            );
          }

          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {

              final data = classes[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.class_),
                  ),

                  title: Text(
                    "${data["className"]} - ${data["section"]}",
                  ),

                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await firestoreService.deleteClass(data.id);
                    },
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