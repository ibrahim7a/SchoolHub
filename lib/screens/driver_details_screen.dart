import 'package:flutter/material.dart';
import 'assign_bus_screen.dart';

class DriverDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> driverData;
  final String driverId;

  const DriverDetailsScreen({
    super.key,
    required this.driverId,
    required this.driverData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(driverData['name']),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(driverData['name']),
                subtitle: Text(driverData['phone']),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.badge),
                title: const Text("License Number"),
                subtitle: Text(driverData['licenseNumber']),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: Icon(
                  Icons.circle,
                  color: driverData['status'] == "Online"
                      ? Colors.green
                      : Colors.red,
                ),
                title: const Text("Status"),
                subtitle: Text(driverData['status']),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssignBusScreen(
                        driverId: driverId,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.directions_bus),
                label: const Text("Assign Bus"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Next Step
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Driver"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Next Step
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete Driver"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}