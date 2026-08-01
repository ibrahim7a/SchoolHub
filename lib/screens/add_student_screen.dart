import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class AddStudentScreen extends StatefulWidget {
  final String? studentId;
  final Map<String, dynamic>? studentData;

  const AddStudentScreen({
    super.key,
    this.studentId,
    this.studentData,
  });

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController _nameController =
  TextEditingController();

  String? selectedClass;
  String? selectedBusId;
  String? selectedParentId;

  @override
  void initState() {
    super.initState();

    if (widget.studentData != null) {
      _nameController.text =
          widget.studentData!["name"] ?? "";

      selectedClass =
      widget.studentData!["className"];

      selectedBusId =
      widget.studentData!["busId"];

      selectedParentId =
      widget.studentData!["parentId"];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> saveStudent() async {
    if (_nameController.text.trim().isEmpty ||
        selectedClass == null ||
        selectedBusId == null ||
        selectedParentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    if (widget.studentId == null) {
      await firestoreService.addStudent(
        studentId:
        DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        className: selectedClass!.trim(),
        busId: selectedBusId!,
        parentId: selectedParentId!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Student Added Successfully",
          ),
        ),
      );
    } else {
      await firestoreService.updateStudent(
        studentId: widget.studentId!,
        name: _nameController.text.trim(),
        className: selectedClass!.trim(),
        busId: selectedBusId!,
        parentId: selectedParentId!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Student Updated Successfully",
          ),
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.studentId == null
              ? "Add Student"
              : "Edit Student",
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Student Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getClasses(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return DropdownButtonFormField<String>(
                  value: selectedClass,
                  decoration: const InputDecoration(
                    labelText: "Select Class",
                    border: OutlineInputBorder(),
                  ),
                  items: snapshot.data!.docs.map((doc) {

                    final className =
                        "${doc["className"]} ${doc["section"]}";

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

            const SizedBox(height: 15),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getBusDropdown(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return DropdownButtonFormField<String>(
                  value: selectedBusId,
                  decoration: const InputDecoration(
                    labelText: "Select Bus",
                    border: OutlineInputBorder(),
                  ),
                  items: snapshot.data!.docs.map((bus) {

                    return DropdownMenuItem(
                      value: bus.id,
                      child: Text(bus["busNumber"]),
                    );

                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedBusId = value;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 15),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getParentsDropdown(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return DropdownButtonFormField<String>(
                  value: selectedParentId,
                  decoration: const InputDecoration(
                    labelText: "Select Parent",
                    border: OutlineInputBorder(),
                  ),
                  items: snapshot.data!.docs.map((parent) {

                    return DropdownMenuItem(
                      value: parent.id,
                      child: Text(parent["name"]),
                    );

                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedParentId = value;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: Icon(
                  widget.studentId == null
                      ? Icons.save
                      : Icons.edit,
                ),
                label: Text(
                  widget.studentId == null
                      ? "Save Student"
                      : "Update Student",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: saveStudent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}