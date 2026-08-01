import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirestoreService firestoreService = FirestoreService();
  final AuthService authService = AuthService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  String? selectedSubject;
  String? selectedClass;

  @override
  void initState() {
    super.initState();

    if (widget.teacherData != null) {
      nameController.text = widget.teacherData!["name"] ?? "";
      emailController.text = widget.teacherData!["email"] ?? "";
      phoneController.text = widget.teacherData!["phone"] ?? "";

      selectedSubject = widget.teacherData!["subject"];
      selectedClass = widget.teacherData!["className"];
    }
  }

  final List<String> subjects = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.teacherId == null
            ? "Add Teacher"
            : "Edit Teacher",
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
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            if (widget.teacherId == null) ...[
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
          ],

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

                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final classes = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  value: selectedClass,
                  decoration: const InputDecoration(
                    labelText: "Assign Class",
                    border: OutlineInputBorder(),
                  ),
                  items: classes.map((doc) {
                    final className =
                        "${doc['className']} ${doc['section']}";

                    return DropdownMenuItem<String>(
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
                child: Text(
                    widget.teacherId == null
                    ? "Save Teacher"
                    : "Update Teacher",
                ),
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      selectedSubject == null ||
                      selectedClass == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all fields"),
                      ),
                    );
                    return;
                  }

                  // ADD TEACHER
                  if (widget.teacherId == null) {
                    if (passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter password"),
                        ),
                      );
                      return;
                    }

                    final credential = await authService.createTeacher(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );

                    await firestoreService.addTeacher(
                      teacherId: credential.user!.uid,
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      phone: phoneController.text.trim(),
                      subject: selectedSubject!,
                      className: selectedClass!,
                    );

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Teacher Added Successfully"),
                      ),
                    );
                  }

                  // EDIT TEACHER
                  else {
                    await firestoreService.updateTeacher(
                      teacherId: widget.teacherId!,
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      phone: phoneController.text.trim(),
                      subject: selectedSubject!,
                      className: selectedClass!,
                    );

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Teacher Updated Successfully"),
                      ),
                    );
                  }

                  Navigator.pop(context);
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}