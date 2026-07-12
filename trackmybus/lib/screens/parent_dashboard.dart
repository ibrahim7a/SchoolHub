import 'package:flutter/material.dart';
import 'bus_tracking_screen.dart';
import '../widgets/dashboard_card.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          DashboardCard(
            icon: Icons.directions_bus,
            title: "Bus Tracking",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BusTrackingScreen(),
                ),
              );
            },
          ),

          const DashboardCard(
            icon: Icons.person_pin_circle,
            title: "Child Location",
          ),

          const DashboardCard(
            icon: Icons.check_circle,
            title: "Attendance",
          ),

          const DashboardCard(
            icon: Icons.book,
            title: "Homework",
          ),

          const DashboardCard(
            icon: Icons.bar_chart,
            title: "Results",
          ),

          const DashboardCard(
            icon: Icons.notifications,
            title: "Notices",
          ),
        ],
      ),
    );
  }
}

