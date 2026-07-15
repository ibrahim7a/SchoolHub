import 'package:flutter/material.dart';
import 'package:trackmybus/screens/class_attendance.screen.dart';
import 'student_management.dart';
import '../widgets/dashboard_card.dart';
import 'bus_management.dart';
import 'driver/driver_management.dart';
import 'attendance_screen.dart';
import 'attendance_history_screen.dart';
import 'homework_screen.dart';
import 'fees_screen.dart';
import 'class_attendance.screen.dart';
import 'parent/parent_management.dart';
import 'parent/result_management.dart';

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

          DashboardCard(
            icon: Icons.family_restroom,
            title: "Parents",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParentManagement(),
                ),
              );
            },
          ),

          DashboardCard(
            icon: Icons.fact_check,
            title: "Attendance",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (__) => const ClassAttendanceScreen(),
                ),
              );
            },
          ),

          DashboardCard(
            icon: Icons.history,
            title: "Attendance History",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceHistoryScreen(),
                ),
              );
            },
          ),

          DashboardCard(
            icon: Icons.menu_book,
            title: "Homework",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeworkScreen(),
                ),
              );
            },
          ),

          DashboardCard(
            icon: Icons.assessment,
            title: "Results",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultManagement(),
                ),
              );
            },
          ),

          DashboardCard(
            icon: Icons.currency_rupee,
            title: "Fees",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

