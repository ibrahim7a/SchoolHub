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
  void initState() {
    super.initState();

    if (widget.teacherData != null) {
      nameController.text =
          widget.teacherData!["name"] ?? "";

      emailController.text =
          widget.teacherData!["email"] ?? "";

      phoneController.text =
          widget.teacherData!["phone"] ?? "";

      selectedSubject =
      widget.teacherData!["subject"];

      // Old data ko handle karna
      final oldClass =
      widget.teacherData!["className"];

      if (oldClass != null) {
        selectedClass = oldClass
            .toString()
            .trim();

        // "class 10" -> "Class 10"
        if (selectedClass!.isNotEmpty) {
          selectedClass =
              selectedClass![0].toUpperCase() +
                  selectedClass!.substring(1);
        }
      }
    }
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

            // ================= NAME =================

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Teacher Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ================= EMAIL =================

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ================= PHONE =================

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ================= PASSWORD =================

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

            // ================= SUBJECT =================

            DropdownButtonFormField<String>(
              value: selectedSubject,

              decoration: const InputDecoration(
                labelText: "Subject",
                border: OutlineInputBorder(),
              ),

              items: subjects.map((subject) {
                return DropdownMenuItem<String>(
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

            // ================= CLASS =================

            StreamBuilder<
                QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getClasses(),

              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Text(
                    "Error loading classes: ${snapshot.error}",
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Text(
                    "No Classes Found",
                  );
                }

                final classes =
                    snapshot.data!.docs;

                // Class names prepare karna
                final classNames =
                classes.map((doc) {

                  final className =
                  doc["className"]
                      .toString()
                      .trim();

                  final section =
                  doc["section"]
                      .toString()
                      .trim();

                  String finalClass;

                  if (section.isEmpty) {
                    finalClass = className;
                  } else {
                    finalClass =
                    "$className $section";
                  }

                  // First letter capital
                  if (finalClass.isNotEmpty) {
                    finalClass =
                        finalClass[0].toUpperCase() +
                            finalClass.substring(1);
                  }

                  return finalClass;

                }).toSet().toList();

                // Agar purana selectedClass
                // dropdown me available nahi hai
                String? dropdownValue;

                if (selectedClass != null &&
                    classNames.contains(selectedClass)) {
                  dropdownValue = selectedClass;
                }

                return DropdownButtonFormField<String>(
                  value: dropdownValue,

                  decoration: const InputDecoration(
                    labelText: "Assign Class",
                    border: OutlineInputBorder(),
                  ),

                  items: classNames.map((className) {

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

            // ================= SAVE / UPDATE =================

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

                  if (nameController.text
                      .trim()
                      .isEmpty ||
                      emailController.text
                          .trim()
                          .isEmpty ||
                      phoneController.text
                          .trim()
                          .isEmpty ||
                      selectedSubject == null ||
                      selectedClass == null) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content:
                        Text("Please fill all fields"),
                      ),
                    );

                    return;
                  }

                  // ================= ADD TEACHER =================

                  if (widget.teacherId == null) {

                    if (passwordController.text
                        .trim()
                        .isEmpty) {

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content:
                          Text("Please enter password"),
                        ),
                      );

                      return;
                    }

                    final credential =
                    await authService.createTeacher(
                      email: emailController.text
                          .trim(),
                      password:
                      passwordController.text
                          .trim(),
                    );

                    await firestoreService.addTeacher(
                      teacherId:
                      credential.user!.uid,
                      name: nameController.text
                          .trim(),
                      email: emailController.text
                          .trim(),
                      phone: phoneController.text
                          .trim(),
                      subject: selectedSubject!,
                      className: selectedClass!,
                    );

                    if (!mounted) return;

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Teacher Added Successfully",
                        ),
                      ),
                    );
                  }

                  // ================= EDIT TEACHER =================

                  else {

                    await firestoreService.updateTeacher(
                      teacherId:
                      widget.teacherId!,
                      name: nameController.text
                          .trim(),
                      email: emailController.text
                          .trim(),
                      phone: phoneController.text
                          .trim(),
                      subject: selectedSubject!,
                      className: selectedClass!,
                    );

                    if (!mounted) return;

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Teacher Updated Successfully",
                        ),
                      ),
                    );
                  }

                  if (!mounted) return;

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