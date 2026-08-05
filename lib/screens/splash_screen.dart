import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

import 'login_screen.dart';
import 'admin_dashboard.dart';
import 'parent_dashboard.dart';
import 'teacher/teacher_dashboard.dart';
import 'driver/driver_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  Future<void> checkLogin() async {
    // Splash screen ko 3 seconds dikhayenge
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Firebase check karega user already logged in hai ya nahi
    final User? user = FirebaseAuth.instance.currentUser;

    // =====================================================
    // USER NOT LOGGED IN
    // =====================================================

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );

      return;
    }

    // =====================================================
    // USER ALREADY LOGGED IN
    // =====================================================

    try {
      final role = await authService.getUserRole(user);

      if (!mounted) return;

      if (role == null) {
        // Role nahi mila
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );

        return;
      }

      // ===================================================
      // ADMIN
      // ===================================================

      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminDashboard(),
          ),
        );
      }

      // ===================================================
      // TEACHER
      // ===================================================

      else if (role == "teacher") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TeacherDashboard(),
          ),
        );
      }

      // ===================================================
      // PARENT
      // ===================================================

      else if (role == "parent") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ParentDashboard(),
          ),
        );
      }

      // ===================================================
      // DRIVER
      // ===================================================

      else if (role == "driver") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DriverDashboard(),
          ),
        );
      }

      // ===================================================
      // UNKNOWN ROLE
      // ===================================================

      else {
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: const Center(
        child: Text(
          "SchoolHub",
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}