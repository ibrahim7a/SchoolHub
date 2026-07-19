import 'package:flutter/material.dart';
import 'bus_tracking_screen.dart';
import '../widgets/dashboard_card.dart';
import 'my_child_screen.dart';
import 'parent/parent_attendance_screen.dart';
import 'parent/parent_homework_screen.dart';
import 'parent/parent_result_screen.dart';

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

          DashboardCard(
            icon: Icons.person,
            title: "My Child",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyChildScreen(),
                ),
              );
            },
          ),

          DashboardCard(
            icon: Icons.check_circle,
            title: "Attendance",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ParentAttendanceScreen(),
                ),
              );
            },
          ),

          DashboardCard(
            icon: Icons.book,
            title: "Homework",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ParentHomeworkScreen(),
                ),
              );
            },
          ),

          DashboardCard(
            icon: Icons.bar_chart,
            title: "Results",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ParentResultScreen(),
                ),
              );
            },
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

