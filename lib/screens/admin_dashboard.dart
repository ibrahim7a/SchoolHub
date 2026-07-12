import 'package:flutter/material.dart';
import 'student_management.dart';
import '../widgets/dashboard_card.dart';
import 'bus_management.dart';
import 'driver_management.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("SchoolHub Admin"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.1,
        children: [
          DashboardCard(
            icon: Icons.people,
            title: "Students",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentManagement(),
                ),
              );
            },
          ),

          const DashboardCard(
            icon: Icons.school,
            title: "Teachers",
          ),

          DashboardCard(
            icon: Icons.directions_bus,
            title: "Buses",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BusManagement(),
                ),
              );
            },
          ),

          DashboardCard(
            icon: Icons.drive_eta,
            title: "Drivers",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DriverManagement(),
                ),
              );
            },
          ),

          const DashboardCard(
            icon: Icons.class_,
            title: "Classes",
          ),

          const DashboardCard(
            icon: Icons.payments,
            title: "Fees",
          ),

          const DashboardCard(
            icon: Icons.campaign,
            title: "Notices",
          ),
        ],
      ),
    );
  }
}

