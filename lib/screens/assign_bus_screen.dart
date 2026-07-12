import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

class AssignBusScreen extends StatefulWidget {
  final String driverId;

  const AssignBusScreen({
    super.key,
    required this.driverId,
  });

  @override
  State<AssignBusScreen> createState() => _AssignBusScreenState();
}

class _AssignBusScreenState extends State<AssignBusScreen> {
  final FirestoreService firestoreService = FirestoreService();

  String? selectedBusId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Bus"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestoreService.getBuses(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final buses = snapshot.data!.docs;

            return Column(
              children: [

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Select Bus",
                  ),

                  items: buses.map((bus) {
                    return DropdownMenuItem(
                      value: bus.id,
                      child: Text(bus['busNumber']),
                    );
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedBusId = value;
                    });
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {

                      if (selectedBusId == null) return;

                      await firestoreService.assignBusToDriver(
                        driverId: widget.driverId,
                        busId: selectedBusId!,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Bus Assigned Successfully"),
                        ),
                      );

                      Navigator.pop(context);
                    },
                    child: const Text("Assign Bus"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}