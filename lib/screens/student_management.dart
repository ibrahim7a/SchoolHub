import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';
import 'add_student_screen.dart';
import 'student_details_screen.dart';

class StudentManagement extends StatefulWidget {
  const StudentManagement({super.key});

  @override
  State<StudentManagement> createState() => _StudentManagementState();
}

class _StudentManagementState extends State<StudentManagement> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController searchController = TextEditingController();

  String searchText = "";
  String? selectedClass = "All";

  final List<String> classList = [
    "All",
    "class 1",
    "class 2",
    "class 3",
    "class 4",
    "class 5",
    "class 6",
    "class 7",
    "class 8",
    "class 9",
    "class 10",
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Management"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.person_add),
        label: const Text("Add"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddStudentScreen(),
            ),
          );
        },
      ),

      body: Column(
        children: [

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Student...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    searchController.clear();

                    setState(() {
                      searchText = "";
                    });
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButtonFormField<String>(
              value: selectedClass,
              decoration: InputDecoration(
                labelText: "Select Class",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              items: classList.map((className) {
                return DropdownMenuItem(
                  value: className,
                  child: Text(className),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value!;
                });
              },
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: firestoreService.getStudentsOrdered(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Students Found",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  final filteredStudents = docs.where((doc) {
                    final student = doc.data();

                    final name = student["name"]
                        .toString()
                        .toLowerCase();

                    final studentClass = student["className"].toString().trim().toLowerCase();

                    final matchesSearch = name.contains(searchText);

                    final matchesClass =
                        selectedClass.toLowerCase() == "all" ||
                            studentClass == selectedClass.toLowerCase();

                    return matchesSearch && matchesClass;
                  }).toList();

                  if (filteredStudents.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Matching Student",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {

                      final student =
                      filteredStudents[index].data();

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),

                          title: Text(
                            student["name"] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              const SizedBox(height: 5),

                              Text(
                                "Class : ${student["className"]}",
                              ),

                              Text(
                                "Bus ID : ${student["busId"]}",
                              ),
                            ],
                          ),

                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StudentDetailsScreen(studentId: filteredStudents[index].id,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}