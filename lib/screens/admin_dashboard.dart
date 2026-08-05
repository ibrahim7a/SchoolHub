import 'package:flutter/material.dart';
import 'package:trackmybus/services/auth_service.dart';

import 'student_management.dart';
import '../widgets/dashboard_card.dart';
import 'bus_management.dart';
import 'driver/driver_management.dart';
import 'attendance_history_screen.dart';
import 'homework_screen.dart';
import 'fees_screen.dart';
import 'class_attendance.screen.dart';
import 'parent/parent_management.dart';
import 'parent/result_management.dart';
import 'class_management_screen.dart';
import 'teacher/teacher_management.dart';
import 'login_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Future<void> logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
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

    // Firebase logout
    await AuthService().signOut();

    if (!context.mounted) return;

    // Clear all previous screens and open Login Screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("SchoolHub Admin"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,

        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout(context);
            },
          ),
        ],
      ),

      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.1,

        children: [

          // ================= STUDENTS =================

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

          // ================= CLASSES =================

          DashboardCard(
            icon: Icons.class_,
            title: "Class Management",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClassManagementScreen(),
                ),
              );
            },
          ),

          // ================= TEACHERS =================

          DashboardCard(
            icon: Icons.school,
            title: "Teachers",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TeacherManagement(),
                ),
              );
            },
          ),

          // ================= BUSES =================

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

          // ================= DRIVERS =================

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

          // ================= PARENTS =================

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

          // ================= ATTENDANCE =================

          DashboardCard(
            icon: Icons.fact_check,
            title: "Attendance",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClassAttendanceScreen(),
                ),
              );
            },
          ),

          // ================= ATTENDANCE HISTORY =================

          DashboardCard(
            icon: Icons.history,
            title: "Attendance History",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttendanceHistoryScreen(),
                ),
              );
            },
          ),

          // ================= HOMEWORK =================

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

          // ================= RESULTS =================

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

          // ================= FEES =================

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