import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  // =====================================================
  // LOGOUT
  // =====================================================

  Future<void> logout() async {
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
  // NAVIGATE TO SCREEN
  // =====================================================

  void openScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  // =====================================================
  // HOME
  // =====================================================

  Widget buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =================================================
          // WELCOME CARD
          // =================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 35,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome, Admin",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        FirebaseAuth.instance.currentUser?.email ??
                            "School Admin",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Quick Access",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.1,
            children: [
              DashboardCard(
                icon: Icons.people,
                title: "Students",
                onTap: () {
                  openScreen(
                    const StudentManagement(),
                  );
                },
              ),

              DashboardCard(
                icon: Icons.school,
                title: "Teachers",
                onTap: () {
                  openScreen(
                    const TeacherManagement(),
                  );
                },
              ),

              DashboardCard(
                icon: Icons.directions_bus,
                title: "Buses",
                onTap: () {
                  openScreen(
                    const BusManagement(),
                  );
                },
              ),

              DashboardCard(
                icon: Icons.fact_check,
                title: "Attendance",
                onTap: () {
                  openScreen(
                    const ClassAttendanceScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // MANAGEMENT
  // =====================================================

  Widget buildManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Management",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Manage your school",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 20),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.1,
            children: [
              // STUDENTS

              DashboardCard(
                icon: Icons.people,
                title: "Students",
                onTap: () {
                  openScreen(
                    const StudentManagement(),
                  );
                },
              ),

              // CLASSES

              DashboardCard(
                icon: Icons.class_,
                title: "Classes",
                onTap: () {
                  openScreen(
                    const ClassManagementScreen(),
                  );
                },
              ),

              // TEACHERS

              DashboardCard(
                icon: Icons.school,
                title: "Teachers",
                onTap: () {
                  openScreen(
                    const TeacherManagement(),
                  );
                },
              ),

              // BUSES

              DashboardCard(
                icon: Icons.directions_bus,
                title: "Buses",
                onTap: () {
                  openScreen(
                    const BusManagement(),
                  );
                },
              ),

              // DRIVERS

              DashboardCard(
                icon: Icons.drive_eta,
                title: "Drivers",
                onTap: () {
                  openScreen(
                    const DriverManagement(),
                  );
                },
              ),

              // PARENTS

              DashboardCard(
                icon: Icons.family_restroom,
                title: "Parents",
                onTap: () {
                  openScreen(
                    ParentManagement(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // REPORTS
  // =====================================================

  Widget buildReports() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Reports & Records",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "View school records and reports",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 20),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.1,
            children: [
              // ATTENDANCE

              DashboardCard(
                icon: Icons.fact_check,
                title: "Attendance",
                onTap: () {
                  openScreen(
                    const ClassAttendanceScreen(),
                  );
                },
              ),

              // ATTENDANCE HISTORY

              DashboardCard(
                icon: Icons.history,
                title: "Attendance History",
                onTap: () {
                  openScreen(
                    const AttendanceHistoryScreen(),
                  );
                },
              ),

              // HOMEWORK

              DashboardCard(
                icon: Icons.menu_book,
                title: "Homework",
                onTap: () {
                  openScreen(
                    HomeworkScreen(),
                  );
                },
              ),

              // RESULTS

              DashboardCard(
                icon: Icons.assessment,
                title: "Results",
                onTap: () {
                  openScreen(
                    ResultManagement(),
                  );
                },
              ),

              // FEES

              DashboardCard(
                icon: Icons.currency_rupee,
                title: "Fees",
                onTap: () {
                  openScreen(
                    FeesScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // SETTINGS
  // =====================================================

  Widget buildSettings() {
    final email =
        FirebaseAuth.instance.currentUser?.email ??
            "Admin Account";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // PROFILE

          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.admin_panel_settings,
              size: 55,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            "School Admin",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            email,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 35),

          // ACCOUNT

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: const Text("Admin Profile"),
              subtitle: const Text(
                "Manage administrator account",
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 10),

          // SCHOOL SETTINGS

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.school,
                color: Colors.blue,
              ),
              title: const Text("School Settings"),
              subtitle: const Text(
                "Manage school information",
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 25),

          // LOGOUT

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: logout,
              icon: const Icon(Icons.logout),
              label: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
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
  // BODY
  // =====================================================

  Widget getCurrentPage() {
    switch (selectedIndex) {
      case 0:
        return buildHome();

      case 1:
        return buildManagement();

      case 2:
        return buildReports();

      case 3:
        return buildSettings();

      default:
        return buildHome();
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
        title: const Text(
          "SchoolHub Admin",
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,

        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: logout,
          ),
        ],
      ),

      // =================================================
      // BODY
      // =================================================

      body: getCurrentPage(),

      // =================================================
      // BOTTOM NAVIGATION
      // =================================================

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),

          NavigationDestination(
            icon: Icon(
              Icons.people_outline,
            ),
            selectedIcon: Icon(
              Icons.people,
            ),
            label: "Management",
          ),

          NavigationDestination(
            icon: Icon(
              Icons.bar_chart_outlined,
            ),
            selectedIcon: Icon(
              Icons.bar_chart,
            ),
            label: "Reports",
          ),

          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
            ),
            selectedIcon: Icon(
              Icons.settings,
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}