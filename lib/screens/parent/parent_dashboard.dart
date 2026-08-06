import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

import '../bus_tracking_screen.dart';
import '../my_child_screen.dart';
import 'parent_attendance_screen.dart';
import 'parent_homework_screen.dart';
import 'parent_result_screen.dart';
import '../login_screen.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
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
  // OPEN SCREEN
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
    final user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // =================================================
          // WELCOME HEADER
          // =================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1565C0),
                  Color(0xFF1976D2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [

                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.family_restroom,
                    size: 35,
                    color: Color(0xFF1565C0),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome, Parent 👋",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        user?.email ?? "Parent Account",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          // =================================================
          // QUICK ACCESS GRID
          // =================================================

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.05,
            children: [

              // BUS
              _dashboardCard(
                icon: Icons.directions_bus,
                title: "Bus Tracking",
                iconColor: Colors.blue,
                onTap: () {
                  openScreen(
                    const BusTrackingScreen(),
                  );
                },
              ),

              // CHILD
              _dashboardCard(
                icon: Icons.person,
                title: "My Child",
                iconColor: Colors.green,
                onTap: () {
                  openScreen(
                    MyChildScreen(),
                  );
                },
              ),

              // ATTENDANCE
              _dashboardCard(
                icon: Icons.check_circle,
                title: "Attendance",
                iconColor: Colors.orange,
                onTap: () {
                  openScreen(
                    const ParentAttendanceScreen(),
                  );
                },
              ),

              // HOMEWORK
              _dashboardCard(
                icon: Icons.menu_book,
                title: "Homework",
                iconColor: Colors.purple,
                onTap: () {
                  openScreen(
                    const ParentHomeworkScreen(),
                  );
                },
              ),

              // RESULTS
              _dashboardCard(
                icon: Icons.bar_chart,
                title: "Results",
                iconColor: Colors.red,
                onTap: () {
                  openScreen(
                    const ParentResultScreen(),
                  );
                },
              ),

              // NOTICES
              _dashboardCard(
                icon: Icons.notifications,
                title: "Notices",
                iconColor: Colors.teal,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "No new notices",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 25),

          // =================================================
          // SCHOOL UPDATE
          // =================================================

          const Text(
            "School Updates",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(
                  Icons.notifications,
                  color: Colors.blue,
                ),
              ),
              title: Text(
                "Welcome to SchoolHub",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Stay updated with your child's school activities.",
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // DASHBOARD CARD
  // =====================================================

  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor: iconColor.withValues(alpha: 0.12),
              child: Icon(
                icon,
                size: 30,
                color: iconColor,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // ATTENDANCE PAGE
  // =====================================================

  Widget buildAttendancePage() {
    return const ParentAttendanceScreen();
  }

  // =====================================================
  // BUS PAGE
  // =====================================================

  Widget buildBusPage() {
    return const BusTrackingScreen();
  }

  // =====================================================
  // PROFILE PAGE
  // =====================================================

  Widget buildProfilePage() {
    final user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          const SizedBox(height: 30),

          const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFFE3F2FD),
            child: Icon(
              Icons.person,
              size: 65,
              color: Color(0xFF1565C0),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Parent Account",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            user?.email ?? "No email",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 35),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.email,
                color: Colors.blue,
              ),
              title: const Text("Email"),
              subtitle: Text(
                user?.email ?? "Not available",
              ),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: logout,
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // PAGE TITLE
  // =====================================================

  String getPageTitle() {
    switch (selectedIndex) {
      case 0:
        return "Parent Home";
      case 1:
        return "Attendance";
      case 2:
        return "Bus Tracking";
      case 3:
        return "Profile";
      default:
        return "Parent Home";
    }
  }

  // =====================================================
  // BODY
  // =====================================================

  Widget getCurrentPage() {
    switch (selectedIndex) {
      case 0:
        return buildHome();

      case 1:
        return buildAttendancePage();

      case 2:
        return buildBusPage();

      case 3:
        return buildProfilePage();

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

      // ===================================================
      // APP BAR
      // ===================================================

      appBar: AppBar(
        title: Text(
          getPageTitle(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // ===================================================
      // BODY
      // ===================================================

      body: getCurrentPage(),

      // ===================================================
      // BOTTOM NAVIGATION
      // ===================================================

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),

          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: "Attendance",
          ),

          NavigationDestination(
            icon: Icon(Icons.directions_bus_outlined),
            selectedIcon: Icon(Icons.directions_bus),
            label: "Bus",
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}