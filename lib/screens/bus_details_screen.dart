import 'package:flutter/material.dart';

class BusDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> busData;
  final String busId;

  const BusDetailsScreen({
    super.key,
    required this.busId,
    required this.busData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(busData['busNumber'] ?? 'Bus Details'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Card(
              child: ListTile(
                leading: const Icon(Icons.directions_bus),
                title: Text(busData['busNumber'] ?? ''),
                subtitle: Text(
                  "Driver: ${busData['driverName']}",
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text("Capacity"),
                subtitle: Text(
                  "${busData['capacity']}",
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: Icon(
                  Icons.circle,
                  color: busData['status'] == "Online"
                      ? Colors.green
                      : Colors.red,
                ),
                title: const Text("Status"),
                subtitle: Text(
                  busData['status'],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Next Step
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Bus"),
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
                label: const Text("Delete Bus"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}