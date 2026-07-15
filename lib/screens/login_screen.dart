import 'package:flutter/material.dart';
import 'parent_dashboard.dart';
import 'admin_dashboard.dart';
import 'driver/driver_dashboard.dart';
import 'driver/driver_login_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),

              const Text(
                "Welcome to SchoolHub",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Smart School Management System",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParentDashboard(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.family_restroom),
                  label: const Text("Parent Login"),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person),
                  label: const Text("Teacher Login"),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DriverLoginScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.directions_bus),
                  label: const Text("Driver Login"),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminDashboard(),
                        ),
                      );
                    },
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text("Admin Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}