import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class AddTeacherScreen extends StatefulWidget {
  final String? teacherId;
  final Map<String, dynamic>? teacherData;

  const AddTeacherScreen({
    super.key,
    this.teacherId,
    this.teacherData,
  });

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final firestoreService = FirestoreService();
  final authService = AuthService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  String? selectedSubject;
  String? selectedClass;
  bool isLoading = false;

  final subjects = [
    "English",
    "Urdu",
    "Hindi",
    "Mathematics",
    "Science",
    "Social Studies",
    "Computer",
    "GK",
    "Islamic Studies",
  ];

  @override
  void initState() {
    super.initState();

    final data = widget.teacherData;

    if (data != null) {
      nameController.text = data["name"] ?? "";
      emailController.text = data["email"] ?? "";
      phoneController.text = data["phone"] ?? "";
      selectedSubject = data["subject"];
      selectedClass = data["className"];
    }
  }

  Future<void> saveTeacher() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        selectedSubject == null ||
        selectedClass == null) {
      showMessage("Please fill all fields");
      return;
    }

    if (widget.teacherId == null && password.isEmpty) {
      showMessage("Please enter password");
      return;
    }

    if (!email.contains("@") || !email.contains(".")) {
      showMessage("Please enter a valid email address");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (widget.teacherId == null) {
        final credential = await authService.createTeacher(
          email: email,
          password: password,
        );

        final uid = credential.user!.uid;

        await firestoreService.addTeacher(
          teacherId: uid,
          name: name,
          email: email,
          phone: phone,
          subject: selectedSubject!,
          className: selectedClass!,
        );

        await authService.createUserProfile(
          uid: uid,
          name: name,
          email: email,
          role: "teacher",
        );

        showMessage("Teacher Added Successfully");
      } else {
        await firestoreService.updateTeacher(
          teacherId: widget.teacherId!,
          name: name,
          email: email,
          phone: phone,
          subject: selectedSubject!,
          className: selectedClass!,
        );

        showMessage("Teacher Updated Successfully");
      }

      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = "Failed to add teacher";

      if (e.code == "email-already-in-use") {
        message = "This email is already registered";
      } else if (e.code == "invalid-email") {
        message = "Please enter a valid email address";
      } else if (e.code == "weak-password") {
        message = "Password must be at least 6 characters";
      }

      showMessage(message);
    } catch (e) {
      showMessage("Something went wrong");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.teacherId == null ? "Add Teacher" : "Edit Teacher",
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Teacher Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),
            if (widget.teacherId == null) ...[
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedSubject,
              decoration: const InputDecoration(
                labelText: "Subject",
                border: OutlineInputBorder(),
              ),
              items: subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
            ),
            const SizedBox(height: 15),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getClasses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Text("No Classes Found");
                }

                final classes = snapshot.data!.docs.map((doc) {
                  final className =
                  doc["className"].toString().trim();
                  final section =
                  doc["section"].toString().trim();

                  return section.isEmpty
                      ? className
                      : "$className $section";
                }).toSet().toList();

                return DropdownButtonFormField<String>(
                  value: classes.contains(selectedClass)
                      ? selectedClass
                      : null,
                  decoration: const InputDecoration(
                    labelText: "Assign Class",
                    border: OutlineInputBorder(),
                  ),
                  items: classes.map((className) {
                    return DropdownMenuItem(
                      value: className,
                      child: Text(className),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedClass = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveTeacher,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                  widget.teacherId == null
                      ? "Save Teacher"
                      : "Update Teacher",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}