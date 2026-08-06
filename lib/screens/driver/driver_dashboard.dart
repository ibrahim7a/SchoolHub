import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirestoreService firestoreService = FirestoreService();

  // =====================================================
  // DRIVER DATA
  // =====================================================

  String driverName = "";
  String busNumber = "";
  String assignedBusId = "";

  // =====================================================
  // DRIVER STATUS
  // =====================================================

  String status = "Offline";
  String location = "Waiting for GPS...";

  StreamSubscription<Position>? positionStream;

  // =====================================================
  // BOTTOM NAVIGATION
  // =====================================================

  int selectedIndex = 0;

  // =====================================================
  // START LIVE TRACKING
  // =====================================================

  Future<void> startLiveTracking() async {
    if (positionStream != null) return;

    if (assignedBusId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bus is not assigned to this driver"),
        ),
      );
      return;
    }

    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (!mounted) return;

      setState(() {
        location = "Please Turn ON GPS";
      });

      return;
    }

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
      await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      if (!mounted) return;

      setState(() {
        location = "Location Permission Denied";
      });

      return;
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;

      setState(() {
        location = "Location Permission Denied Forever";
      });

      return;
    }

    if (!mounted) return;

    setState(() {
      status = "Online";
      location = "Getting GPS location...";
    });

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 2,
          ),
        ).listen(
              (Position position) async {
            if (!mounted) return;

            setState(() {
              status = "Online";

              location =
              "Latitude: ${position.latitude}\n"
                  "Longitude: ${position.longitude}";
            });

            await firestore
                .collection("buses")
                .doc(assignedBusId)
                .set(
              {
                "busNumber": busNumber,
                "driverName": driverName,
                "latitude": position.latitude,
                "longitude": position.longitude,
                "status": "Online",
                "updatedAt":
                FieldValue.serverTimestamp(),
              },
              SetOptions(merge: true),
            );
          },
        );
  }

  // =====================================================
  // LOAD DRIVER DATA
  // =====================================================

  Future<void> loadDriverData() async {
    final user = auth.currentUser;

    if (user == null) return;

    try {
      final query = await firestore
          .collection("drivers")
          .where(
        "email",
        isEqualTo: user.email,
      )
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Driver data not found"),
          ),
        );

        return;
      }

      final data = query.docs.first.data();

      assignedBusId =
          data["assignedBusId"] ?? "";

      driverName =
          data["name"] ?? "Driver";

      if (assignedBusId.isNotEmpty) {
        final bus = await firestore
            .collection("buses")
            .doc(assignedBusId)
            .get();

        if (bus.exists) {
          final busData = bus.data();

          busNumber =
              busData?["busNumber"] ?? "";
        }
      }

      if (!mounted) return;

      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error loading driver data: $e",
          ),
        ),
      );
    }
  }

  // =====================================================
  // STOP TRACKING
  // =====================================================

  Future<void> stopTracking() async {
    await positionStream?.cancel();

    positionStream = null;

    if (mounted) {
      setState(() {
        status = "Offline";
        location = "Trip Ended";
      });
    }

    if (assignedBusId.isNotEmpty) {
      await firestore
          .collection("buses")
          .doc(assignedBusId)
          .set(
        {
          "status": "Offline",
          "updatedAt":
          FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }
  }

  // =====================================================
  // LOGOUT
  // =====================================================

  Future<void> logout() async {
    final shouldLogout =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text(
            "Are you sure you want to logout?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    if (positionStream != null) {
      await stopTracking();
    }

    await AuthService().signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  // =====================================================
  // INIT
  // =====================================================

  @override
  void initState() {
    super.initState();

    loadDriverData();
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    positionStream?.cancel();

    super.dispose();
  }

  // =====================================================
  // HOME PAGE
  // =====================================================

  Widget buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // DRIVER HEADER
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          driverName.isEmpty
                              ? "Driver"
                              : driverName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Bus No: ${busNumber.isEmpty ? "Not Assigned" : busNumber}",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // STATUS CARD
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.all(16),

              leading: CircleAvatar(
                backgroundColor:
                status == "Online"
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                child: Icon(
                  Icons.circle,
                  color:
                  status == "Online"
                      ? Colors.green
                      : Colors.red,
                ),
              ),

              title: const Text(
                "Driver Status",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(status),

              trailing: Text(
                status,
                style: TextStyle(
                  color:
                  status == "Online"
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // QUICK ACTIONS
          Row(
            children: [
              Expanded(
                child: _quickActionCard(
                  icon: Icons.directions_bus,
                  title: "Trip",
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: _quickActionCard(
                  icon: Icons.location_on,
                  title: "Live Location",
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // QUICK ACTION CARD
  // =====================================================

  Widget _quickActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 25,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.blue,
              ),

              const SizedBox(height: 10),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // TRIP PAGE
  // =====================================================

  Widget buildTripPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.directions_bus,
                    size: 70,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Trip Management",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Bus No: ${busNumber.isEmpty ? "Not Assigned" : busNumber}",
                  ),

                  const SizedBox(height: 25),

                  // START TRIP
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed:
                      status == "Online"
                          ? null
                          : startLiveTracking,
                      icon: const Icon(
                        Icons.play_arrow,
                      ),
                      label: const Text(
                        "START TRIP",
                      ),
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.green,
                        foregroundColor:
                        Colors.white,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // END TRIP
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed:
                      status == "Online"
                          ? stopTracking
                          : null,
                      icon: const Icon(
                        Icons.stop,
                      ),
                      label: const Text(
                        "END TRIP",
                      ),
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.red,
                        foregroundColor:
                        Colors.white,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // TRIP STATUS
          Card(
            child: ListTile(
              leading: Icon(
                status == "Online"
                    ? Icons.check_circle
                    : Icons.pause_circle,
                color:
                status == "Online"
                    ? Colors.green
                    : Colors.red,
              ),
              title: const Text(
                "Current Trip Status",
              ),
              subtitle: Text(status),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // LIVE LOCATION PAGE
  // =====================================================

  Widget buildLiveLocationPage() {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
          Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Icon(
                  Icons.location_on,
                  size: 80,
                  color:
                  status == "Online"
                      ? Colors.green
                      : Colors.grey,
                ),

                const SizedBox(height: 15),

                const Text(
                  "Live Location",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Text(
                    location,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

            // ONLINE/OFFLINE
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.circle,
                  color:
                  status == "Online"
                      ? Colors.green
                      : Colors.red,
                ),
                title: const Text(
                  "GPS Tracking",
                ),
                subtitle: Text(
                  status == "Online"
                      ? "Your location is being shared"
                      : "Tracking is currently stopped",
                ),
              ),
            ),

            const Spacer(),

            if (status != "Online")
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: startLiveTracking,
                  icon: const Icon(
                    Icons.location_on,
                  ),
                  label: const Text(
                    "START LIVE LOCATION",
                  ),
                ),
              ),

            if (status == "Online")
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: stopTracking,
                  icon: const Icon(
                    Icons.stop,
                  ),
                  label: const Text(
                    "STOP LIVE LOCATION",
                  ),
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
    );
  }



  // =====================================================
  // PROFILE PAGE
  // =====================================================

  Widget buildProfilePage() {
    final user = auth.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 55,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            driverName.isEmpty
                ? "Driver"
                : driverName,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            user?.email ?? "",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 30),

          // BUS INFORMATION
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.directions_bus,
                color: Colors.blue,
              ),
              title: const Text(
                "Assigned Bus",
              ),
              subtitle: Text(
                busNumber.isEmpty
                    ? "Not Assigned"
                    : busNumber,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // STATUS
          Card(
            child: ListTile(
              leading: Icon(
                Icons.circle,
                color:
                status == "Online"
                    ? Colors.green
                    : Colors.red,
              ),
              title: const Text(
                "Current Status",
              ),
              subtitle: Text(status),
            ),
          ),

          const SizedBox(height: 30),

          // LOGOUT
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: logout,
              icon: const Icon(
                Icons.logout,
              ),
              label: const Text(
                "Logout",
              ),
              style:
              ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // PAGE SELECTOR
  // =====================================================

  Widget getCurrentPage() {
    switch (selectedIndex) {
      case 0:
        return buildHomePage();

      case 1:
        return buildTripPage();

      case 2:
        return buildLiveLocationPage();

      case 3:
        return buildProfilePage();

      default:
        return buildHomePage();
    }
  }

  // =====================================================
  // APP BAR TITLE
  // =====================================================

  String getAppBarTitle() {
    switch (selectedIndex) {
      case 0:
        return "Driver Home";

      case 1:
        return "My Trip";

      case 2:
        return "Live Location";

      case 3:
        return "My Profile";

      default:
        return "Driver Home";
    }
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // =================================================
      // APP BAR
      // =================================================

      appBar: AppBar(
        title: Text(
          getAppBarTitle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),

      // =================================================
      // BODY
      // =================================================

      body: getCurrentPage(),

      // =================================================
      // BOTTOM NAVIGATION
      // =================================================

      bottomNavigationBar:
      BottomNavigationBar(
        currentIndex: selectedIndex,

        type:
        BottomNavigationBarType.fixed,

        selectedItemColor:
        Colors.blue,

        unselectedItemColor:
        Colors.grey,

        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.directions_bus,
            ),
            label: "Trip",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_on,
            ),
            label: "Live Location",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}