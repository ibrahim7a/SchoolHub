import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState
    extends State<AttendanceHistoryScreen> {

  String selectedClass = "All";
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {

    Query attendanceQuery =
    FirebaseFirestore.instance.collection("attendance");

    if (selectedClass != "All") {
      attendanceQuery = attendanceQuery.where(
        "className",
        isEqualTo: selectedClass,
      );
    }

    attendanceQuery =
        attendanceQuery.orderBy("date", descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance History"),
        backgroundColor: Colors.blue,
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [

                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedClass,
                    decoration: const InputDecoration(
                      labelText: "Select Class",
                      border: OutlineInputBorder(),
                    ),
                    items: const [

                      DropdownMenuItem(
                        value: "All",
                        child: Text("All Classes"),
                      ),

                      DropdownMenuItem(
                        value: "class 1",
                        child: Text("Class 1"),
                      ),

                      DropdownMenuItem(
                        value: "class 2",
                        child: Text("Class 2"),
                      ),

                      DropdownMenuItem(
                        value: "class 3",
                        child: Text("Class 3"),
                      ),

                      DropdownMenuItem(
                        value: "class 4",
                        child: Text("Class 4"),
                      ),

                      DropdownMenuItem(
                        value: "class 5",
                        child: Text("Class 5"),
                      ),

                      DropdownMenuItem(
                        value: "class 6",
                        child: Text("Class 6"),
                      ),

                      DropdownMenuItem(
                        value: "class 7",
                        child: Text("Class 7"),
                      ),

                      DropdownMenuItem(
                        value: "class 8",
                        child: Text("Class 8"),
                      ),

                      DropdownMenuItem(
                        value: "class 9",
                        child: Text("Class 9"),
                      ),

                      DropdownMenuItem(
                        value: "class 10",
                        child: Text("Class 10"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedClass = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton.icon(
                  onPressed: () async {

                    final picked =
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2035),
                    );

                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text("Date"),
                ),

              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: attendanceQuery.snapshots(),
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
                    child: Text("No Attendance Found"),
                  );
                }

                List attendance = snapshot.data!.docs;

                if (selectedDate != null) {
                  attendance = attendance.where((doc) {
                    final data =
                    doc.data() as Map<String, dynamic>;

                    final date =
                    (data["date"] as Timestamp).toDate();

                    return date.year == selectedDate!.year &&
                        date.month == selectedDate!.month &&
                        date.day == selectedDate!.day;
                  }).toList();
                }

                if (attendance.isEmpty) {
                  return const Center(
                    child: Text("No Attendance Found"),
                  );
                }

                return ListView.builder(
                  itemCount: attendance.length,
                  itemBuilder: (context, index) {

                    final data =
                    attendance[index].data()
                    as Map<String, dynamic>;

                    final date =
                    (data["date"] as Timestamp).toDate();

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                          data["isPresent"]
                              ? Colors.green
                              : Colors.red,
                          child: Icon(
                            data["isPresent"]
                                ? Icons.check
                                : Icons.close,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(
                          data["studentName"] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Class : ${data["className"]}",
                            ),
                            Text(
                              DateFormat(
                                "dd MMM yyyy  hh:mm a",
                              ).format(date),
                            ),
                          ],
                        ),

                        trailing: Text(
                          data["isPresent"]
                              ? "Present"
                              : "Absent",
                          style: TextStyle(
                            color: data["isPresent"]
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}