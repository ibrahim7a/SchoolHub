import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({super.key});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final licenseController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Driver"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Driver Name",
              ),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
              ),
            ),
            TextField(
              controller: licenseController,
              decoration: const InputDecoration(
                labelText: "License Number",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await firestoreService.addDriver(
                    driverId: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    licenseNumber: licenseController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Driver Added Successfully"),
                    ),
                  );

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              }, // 👈 Ye comma zaroori hai

              child: const Text("Save Driver"),
            ),
          ],
        ),
      ),
    );
  }
}