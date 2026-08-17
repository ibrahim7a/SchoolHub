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

  final TextEditingController _nameController = TextEditingController();

  String? selectedClass;
  String? selectedBusId;
  String? selectedParentId;

  bool isSaving = false;

  bool get isEditing => widget.studentId != null;

  @override
  void initState() {
    super.initState();

    if (widget.studentData != null) {
      final data = widget.studentData!;

      _nameController.text = data["name"]?.toString() ?? "";

      selectedClass = data["className"]?.toString();
      selectedBusId = data["busId"]?.toString();
      selectedParentId = data["parentId"]?.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> saveStudent() async {
    if (isSaving) return;

    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _showMessage("Please enter student name");
      return;
    }

    if (selectedClass == null || selectedClass!.isEmpty) {
      _showMessage("Please select a class");
      return;
    }

    if (selectedBusId == null || selectedBusId!.isEmpty) {
      _showMessage("Please select a bus");
      return;
    }

    if (selectedParentId == null || selectedParentId!.isEmpty) {
      _showMessage("Please select a parent");
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      if (isEditing) {
        await firestoreService.updateStudent(
          studentId: widget.studentId!,
          name: name,
          className: selectedClass!.trim(),
          busId: selectedBusId!,
          parentId: selectedParentId!,
        );
      } else {
        final studentId =
        DateTime.now().millisecondsSinceEpoch.toString();

        await firestoreService.addStudent(
          studentId: studentId,
          name: name,
          className: selectedClass!.trim(),
          busId: selectedBusId!,
          parentId: selectedParentId!,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? "Student updated successfully"
                : "Student added successfully",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to save student: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Student" : "Add Student",
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: "Student Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getClasses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }

                if (snapshot.hasError) {
                  return _errorBox(
                    "Error loading classes: ${snapshot.error}",
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return _emptyBox("No classes found");
                }

                final classNames = <String>[];

                for (final doc in snapshot.data!.docs) {
                  final data = doc.data();

                  final className =
                      data["className"]?.toString().trim() ?? "";

                  final section =
                      data["section"]?.toString().trim() ?? "";

                  if (className.isEmpty) continue;

                  final fullClass = section.isEmpty
                      ? className
                      : "$className $section";

                  if (!classNames.contains(fullClass)) {
                    classNames.add(fullClass);
                  }
                }

                classNames.sort();

                final safeValue =
                classNames.contains(selectedClass)
                    ? selectedClass
                    : null;

                return DropdownButtonFormField<String>(
                  value: safeValue,
                  decoration: const InputDecoration(
                    labelText: "Select Class",
                    prefixIcon: Icon(Icons.school),
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

            const SizedBox(height: 18),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getBusDropdown(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }

                if (snapshot.hasError) {
                  return _errorBox(
                    "Error loading buses: ${snapshot.error}",
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return _emptyBox("No buses found");
                }

                final buses = snapshot.data!.docs;

                final safeValue = buses.any(
                      (bus) => bus.id == selectedBusId,
                )
                    ? selectedBusId
                    : null;

                return DropdownButtonFormField<String>(
                  value: safeValue,
                  decoration: const InputDecoration(
                    labelText: "Select Bus",
                    prefixIcon: Icon(Icons.directions_bus),
                    border: OutlineInputBorder(),
                  ),
                  items: buses.map((bus) {
                    final data = bus.data();

                    final busNumber =
                        data["busNumber"]?.toString() ??
                            "Unknown Bus";

                    return DropdownMenuItem<String>(
                      value: bus.id,
                      child: Text(busNumber),
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

            const SizedBox(height: 18),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreService.getParentsDropdown(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }

                if (snapshot.hasError) {
                  return _errorBox(
                    "Error loading parents: ${snapshot.error}",
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return _emptyBox("No parents found");
                }

                final parents = snapshot.data!.docs;

                final safeValue = parents.any(
                      (parent) => parent.id == selectedParentId,
                )
                    ? selectedParentId
                    : null;

                return DropdownButtonFormField<String>(
                  value: safeValue,
                  decoration: const InputDecoration(
                    labelText: "Select Parent",
                    prefixIcon: Icon(Icons.family_restroom),
                    border: OutlineInputBorder(),
                  ),
                  items: parents.map((parent) {
                    final data = parent.data();

                    final parentName =
                        data["name"]?.toString() ??
                            "Unknown Parent";

                    return DropdownMenuItem<String>(
                      value: parent.id,
                      child: Text(parentName),
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
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : saveStudent,
                icon: isSaving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Icon(
                  isEditing
                      ? Icons.edit
                      : Icons.save,
                ),
                label: Text(
                  isSaving
                      ? "Saving..."
                      : isEditing
                      ? "Update Student"
                      : "Save Student",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.red.shade700,
        ),
      ),
    );
  }

  Widget _emptyBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(message),
    );
  }
}