import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddBusScreen extends StatefulWidget {
  const AddBusScreen({super.key});

  @override
  State<AddBusScreen> createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final busNumberController = TextEditingController();
  final driverNameController = TextEditingController();
  final capacityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Bus"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: busNumberController,
              decoration: const InputDecoration(
                labelText: "Bus Number",
              ),
            ),
            TextField(
              controller: driverNameController,
              decoration: const InputDecoration(
                labelText: "Driver Name",
              ),
            ),
            TextField(
              controller: capacityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Capacity",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await firestoreService.addBus(
                  busId: DateTime.now().millisecondsSinceEpoch.toString(),
                  busNumber: busNumberController.text.trim(),
                  driverName: driverNameController.text.trim(),
                  capacity: int.tryParse(capacityController.text.trim()) ?? 0,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bus Added Successfully"),
                  ),
                );

                busNumberController.clear();
                driverNameController.clear();
                capacityController.clear();

                Navigator.pop(context);
              },
              child: const Text("Save Bus"),
            ),
          ],
        ),
      ),
    );
  }
}