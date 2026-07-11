import 'package:flutter/material.dart';

class BusTrackingScreen extends StatelessWidget {
  const BusTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Bus Tracking"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Map Placeholder
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  "Google Map will appear here",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "🚌 Bus Information",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    ListTile(
                      leading: Icon(Icons.directions_bus),
                      title: Text("Bus Number"),
                      subtitle: Text("TS09 AB 1234"),
                    ),

                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Driver"),
                      subtitle: Text("Mohammed Ahmed"),
                    ),

                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text("Contact"),
                      subtitle: Text("9876543210"),
                    ),

                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text("Status"),
                      subtitle: Text("On the Way"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}