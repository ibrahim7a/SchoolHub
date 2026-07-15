import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final FirestoreService firestoreService = FirestoreService();

String driverName = "";
String busNumber = "";
String assignedBusId = "";

class _DriverDashboardState extends State<DriverDashboard> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String status = "Offline";
  String location = "Waiting for GPS...";

  StreamSubscription<Position>? positionStream;

  Future<void> startLiveTracking() async {
    if (positionStream != null) return;

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        location = "Please Turn ON GPS";
      });
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        location = "Location Permission Denied";
      });
      return;
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 2,
      ),
    ).listen((Position position) async {
      if (!mounted) return;

      setState(() {
        status = "Online";
        location =
        "Latitude: ${position.latitude}\nLongitude: ${position.longitude}";
      });

      await firestore.collection("buses").doc(assignedBusId).set({
        "busNumber": busNumber,
        "driverName": driverName,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "status": "Online",
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  Future<void> loadDriverData() async {
    final user = auth.currentUser;

    if (user == null) return;

    final query = await firestore
        .collection("drivers")
        .where("email", isEqualTo: user.email)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return;

    final data = query.docs.first.data()!;

    assignedBusId = data["assignedBusId"];
    driverName = data["name"];

    final bus =
    await firestore.collection("buses").doc(assignedBusId).get();

    if (bus.exists) {
      busNumber = bus["busNumber"];
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> stopTracking() async {
    await positionStream?.cancel();
    positionStream = null;

    setState(() {
      status = "Offline";
      location = "Trip Ended";
    });

    await firestore.collection("buses").doc(assignedBusId).update({
      "status": "Offline",
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  @override
  void initState() {
    super.initState();
    loadDriverData();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                driverName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                "Bus No: $busNumber",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.circle,
                  color: status == "Online"
                      ? Colors.green
                      : Colors.red,
                ),
                title: const Text("Status"),
                subtitle: Text(status),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await startLiveTracking();
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("START TRIP"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () async {
                await stopTracking();
              },
              icon: const Icon(Icons.stop),
              label: const Text("END TRIP"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text("Current Location"),
                  subtitle: Text(location),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}