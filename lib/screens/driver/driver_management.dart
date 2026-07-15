import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/firestore_service.dart';
import 'add_driver_screen.dart';
import 'driver_details_screen.dart';

class DriverManagement extends StatefulWidget {
  const DriverManagement({super.key});

  @override
  State<DriverManagement> createState() => _DriverManagementState();
}

class _DriverManagementState extends State<DriverManagement> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Management"),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDriverScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getDrivers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Drivers Added",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final drivers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              final driver = drivers[index].data();

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DriverDetailsScreen(
                          driverId: drivers[index].id,
                          driverData: driver,
                        ),
                      ),
                    );
                  },
                  title: Text(driver['name'] ?? ''),
                  subtitle: Text(
                    "Phone: ${driver['phone']}\nLicense: ${driver['licenseNumber']}",
                  ),
                  trailing: Icon(
                    Icons.circle,
                    color: driver['status'] == "Online"
                        ? Colors.green
                        : Colors.red,
                    size: 16,
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