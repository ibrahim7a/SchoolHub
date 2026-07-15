import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

class BusTrackingScreen extends StatefulWidget {
  const BusTrackingScreen({super.key});

  @override
  State<BusTrackingScreen> createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends State<BusTrackingScreen> {
  final MapController _mapController = MapController();
  final FirestoreService firestoreService = FirestoreService();

  LatLng busLocation = const LatLng(17.3850, 78.4867);

  @override
  void initState() {
    super.initState();

    firestoreService.getBusLocation("bus1").listen((snapshot) {
      if (!snapshot.exists) return;

      final data = snapshot.data()!;

      final lat = (data['latitude'] as num).toDouble();
      final lng = (data['longitude'] as num).toDouble();

      final newLocation = LatLng(lat, lng);

      if (mounted) {
        setState(() {
          busLocation = newLocation;
        });

        _mapController.move(newLocation, 15);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Bus Tracking"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getBusLocation("bus1"),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final bus = snapshot.data!.data()!;

          return Column(
            children: [
              Expanded(
                flex: 2,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: busLocation,
                    initialZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: "com.example.trackmybus",
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: busLocation,
                          width: 60,
                          height: 60,
                          child: const Icon(
                            Icons.directions_bus,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: const Icon(
                    Icons.directions_bus,
                    color: Colors.blue,
                  ),
                  title: Text("Bus: ${bus['busNumber']}"),
                  subtitle: Text(
                    "Driver: ${bus['driverName']}\n"
                        "Status: ${bus['status']}",
                  ),
                  trailing: Icon(
                    Icons.circle,
                    color: bus['status'] == "Online"
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}