import 'package:flutter/material.dart';
import 'package:trackmybus/services/auth_service.dart';

import 'parent/parent_dashboard.dart';
import 'admin_dashboard.dart';
import 'driver/driver_dashboard.dart';
import 'teacher/teacher_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  // =====================================================
  // LOGIN
  // =====================================================

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // ================= VALIDATION =================

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter email and password"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // =================================================
      // FIREBASE LOGIN
      // =================================================

      final credential = await authService.signIn(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception("User account not found.");
      }

      // =================================================
      // GET USER ROLE
      // =================================================

      final role = await authService.getUserRole(user);

      if (!mounted) return;

      // =================================================
      // ROLE NOT FOUND
      // =================================================

      if (role == null || role.isEmpty) {
        await authService.signOut();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Your account role was not found. Please contact your school administrator.",
            ),
          ),
        );

        return;
      }

      // =================================================
      // NORMALIZE ROLE
      // =================================================

      final userRole = role.toLowerCase().trim();

      // =================================================
      // ADMIN
      // =================================================

      if (userRole == "admin") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminDashboard(),
          ),
              (route) => false,
        );

        return;
      }

      // =================================================
      // TEACHER
      // =================================================

      if (userRole == "teacher") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const TeacherDashboard(),
          ),
              (route) => false,
        );

        return;
      }

      // =================================================
      // DRIVER
      // =================================================

      if (userRole == "driver") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const DriverDashboard(),
          ),
              (route) => false,
        );

        return;
      }

      // =================================================
      // PARENT
      // =================================================

      if (userRole == "parent") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const ParentDashboard(),
          ),
              (route) => false,
        );

        return;
      }

      // =================================================
      // UNKNOWN ROLE
      // =================================================

      await authService.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unknown user role: $role",
          ),
        ),
      );
    } on Exception catch (e) {
      if (!mounted) return;

      String message = "Login failed.";

      final error = e.toString().toLowerCase();

      if (error.contains("user-not-found")) {
        message = "No account found with this email.";
      } else if (error.contains("wrong-password") ||
          error.contains("invalid-credential")) {
        message = "Incorrect email or password.";
      } else if (error.contains("invalid-email")) {
        message = "Please enter a valid email address.";
      } else if (error.contains("too-many-requests")) {
        message = "Too many attempts. Please try again later.";
      } else if (error.contains("network-request-failed")) {
        message = "Please check your internet connection.";
      } else {
        message = "Login failed. Please try again.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  // =====================================================
  // UI
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [

                // =================================================
                // LOGO
                // =================================================

                const Icon(
                  Icons.school,
                  size: 90,
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

                const SizedBox(height: 8),

                const Text(
                  "Smart School Management System",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 35),

                // =================================================
                // LOGIN CARD
                // =================================================

                Card(
                  elevation: 8,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(24),

                    child: Column(
                      children: [

                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // =================================================
                        // EMAIL
                        // =================================================

                        TextField(
                          controller: emailController,

                          keyboardType:
                          TextInputType.emailAddress,

                          decoration:
                          const InputDecoration(
                            labelText: "Email",
                            prefixIcon:
                            Icon(Icons.email),
                            border:
                            OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // =================================================
                        // PASSWORD
                        // =================================================

                        TextField(
                          controller: passwordController,

                          obscureText:
                          obscurePassword,

                          decoration:
                          InputDecoration(
                            labelText: "Password",

                            prefixIcon:
                            const Icon(Icons.lock),

                            border:
                            const OutlineInputBorder(),

                            suffixIcon:
                            IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),

                              onPressed: () {
                                setState(() {
                                  obscurePassword =
                                  !obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // =================================================
                        // LOGIN BUTTON
                        // =================================================

                        SizedBox(
                          width: double.infinity,
                          height: 52,

                          child:
                          ElevatedButton(
                            onPressed:
                            isLoading
                                ? null
                                : login,

                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(
                                0xFF1565C0,
                              ),

                              foregroundColor:
                              Colors.white,

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  12,
                                ),
                              ),
                            ),

                            child: isLoading
                                ? const SizedBox(
                              height: 25,
                              width: 25,

                              child:
                              CircularProgressIndicator(
                                color:
                                Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              "Login",

                              style:
                              TextStyle(
                                fontSize: 17,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Login with your school account",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}