import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class BusDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> busData;
  final String busId;

  const BusDetailsScreen({
    super.key,
    required this.busId,
    required this.busData,
  });

  @override
  State<BusDetailsScreen> createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen> {
  final FirestoreService firestoreService = FirestoreService();

  String? selectedDriverId;
  String? selectedDriverName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.busData['busNumber'] ?? 'Bus Details'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Card(
              child: ListTile(
                leading: const Icon(Icons.directions_bus),
                title: Text(widget.busData['busNumber'] ?? ''),
                subtitle: Text(
                  "Driver: ${widget.busData['driverName']}",
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text("Capacity"),
                subtitle: Text(
                  "${widget.busData['capacity']}",
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: Icon(
                  Icons.circle,
                  color: widget.busData['status'] == "Online"
                      ? Colors.green
                      : Colors.red,
                ),
                title: const Text("Status"),
                subtitle: Text(
                  widget.busData['status'],
                ),
              ),
            ),

            const SizedBox(height: 20),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getDrivers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final drivers = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Assign Driver",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedDriverId,
                  items: drivers.map((driver) {
                    return DropdownMenuItem<String>(
                      value: driver.id,
                      child: Text(driver['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDriverId = value;

                      final driver =
                      drivers.firstWhere((d) => d.id == value);

                      selectedDriverName = driver['name'];
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (selectedDriverId == null) return;

                  await firestoreService.assignDriverToBus(
                    driverId: selectedDriverId!,
                    driverName: selectedDriverName!,
                    busId: widget.busId,
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Driver Assigned Successfully"),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text("Assign Driver"),
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
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Bus"),
                      content: const Text(
                        "Are you sure you want to delete this bus?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await firestoreService.deleteBus(widget.busId);

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Bus Deleted Successfully"),
                      ),
                    );

                    Navigator.pop(context);
                  }
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