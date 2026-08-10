import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';

import 'teacher_attendance_screen.dart';
import '../homework_screen.dart';
import '../login_screen.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final FirestoreService firestoreService = FirestoreService();

  final User? currentUser = FirebaseAuth.instance.currentUser;

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
  // HOME PAGE
  // =====================================================

  Widget buildHome() {
    if (currentUser == null) {
      return const Center(
        child: Text("Teacher account not found"),
      );
    }

    return FutureBuilder<
        DocumentSnapshot<Map<String, dynamic>>>(
      future: firestoreService.getTeacher(
        currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData ||
            !snapshot.data!.exists ||
            snapshot.data!.data() == null) {
          return const Center(
            child: Text("Teacher data not found"),
          );
        }

        final teacher = snapshot.data!.data()!;

        final String teacherName =
            teacher["name"] ?? "Teacher";

        final String subject =
            teacher["subject"] ?? "Not assigned";

        final String className =
            teacher["className"] ?? "Not assigned";

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
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
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Row(
                  children: [

                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.school,
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

                          Text(
                            "Welcome, $teacherName 👋",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Subject: $subject",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),

                          Text(
                            "Class: $className",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // =================================================
              // QUICK ACCESS
              // =================================================

              GridView.count(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.05,
                children: [

                  // ATTENDANCE

                  teacherCard(
                    icon: Icons.fact_check,
                    title: "Attendance",
                    iconColor: Colors.green,
                    onTap: () {
                      openScreen(
                        const TeacherAttendanceScreen(),
                      );
                    },
                  ),

                  // HOMEWORK

                  teacherCard(
                    icon: Icons.menu_book,
                    title: "Homework",
                    iconColor: Colors.orange,
                    onTap: () {
                      openScreen(
                        HomeworkScreen(),
                      );
                    },
                  ),

                  // RESULTS

                  teacherCard(
                    icon: Icons.assessment,
                    title: "Results",
                    iconColor: Colors.blue,
                    onTap: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Results module coming soon",
                          ),
                        ),
                      );
                    },
                  ),

                  // NOTICES

                  teacherCard(
                    icon: Icons.notifications,
                    title: "Notices",
                    iconColor: Colors.red,
                    onTap: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
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
              // TEACHER INFORMATION
              // =================================================

              const Text(
                "My Teaching Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
                child: Column(
                  children: [

                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor:
                        Color(0xFFE3F2FD),
                        child: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                      ),
                      title: const Text(
                        "Teacher",
                      ),
                      subtitle: Text(
                        teacherName,
                      ),
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor:
                        Color(0xFFE8F5E9),
                        child: Icon(
                          Icons.menu_book,
                          color: Colors.green,
                        ),
                      ),
                      title: const Text(
                        "Subject",
                      ),
                      subtitle: Text(
                        subject,
                      ),
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor:
                        Color(0xFFFFF3E0),
                        child: Icon(
                          Icons.class_,
                          color: Colors.orange,
                        ),
                      ),
                      title: const Text(
                        "Assigned Class",
                      ),
                      subtitle: Text(
                        className,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =====================================================
  // TEACHER CARD
  // =====================================================

  Widget teacherCard({
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
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor:
              iconColor.withValues(alpha: 0.12),
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
    return const TeacherAttendanceScreen();
  }

  // =====================================================
  // HOMEWORK PAGE
  // =====================================================

  Widget buildHomeworkPage() {
    return HomeworkScreen();
  }

  // =====================================================
  // PROFILE PAGE
  // =====================================================

  Widget buildProfilePage() {
    final user =
        FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          const SizedBox(height: 30),

          const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFFE3F2FD),
            child: Icon(
              Icons.school,
              size: 65,
              color: Color(0xFF1565C0),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Teacher Account",
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

          const SizedBox(height: 30),

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

          const SizedBox(height: 20),

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
  // PAGE TITLE
  // =====================================================

  String getPageTitle() {
    switch (selectedIndex) {
      case 0:
        return "Teacher Home";
      case 1:
        return "Attendance";
      case 2:
        return "Homework";
      case 3:
        return "Profile";
      default:
        return "Teacher Home";
    }
  }

  // =====================================================
  // CURRENT PAGE
  // =====================================================

  Widget getCurrentPage() {
    switch (selectedIndex) {
      case 0:
        return buildHome();

      case 1:
        return buildAttendancePage();

      case 2:
        return buildHomeworkPage();

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
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TeacherAttendanceScreen(),
              ),
            );
            return;
          }
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
            icon: Icon(
              Icons.check_circle_outline,
            ),
            selectedIcon: Icon(
              Icons.check_circle,
            ),
            label: "Attendance",
          ),

          NavigationDestination(
            icon: Icon(
              Icons.menu_book_outlined,
            ),
            selectedIcon: Icon(
              Icons.menu_book,
            ),
            label: "Homework",
          ),

          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
            ),
            selectedIcon: Icon(
              Icons.person,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}