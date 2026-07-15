import 'package:flutter/material.dart';

class MyChildScreen extends StatelessWidget {
  const MyChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Child"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 60,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Ahmed Khan",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              "Student ID : STU1001",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.class_),
                    title: Text("Class"),
                    trailing: Text("Class 5A"),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.confirmation_number),
                    title: Text("Roll Number"),
                    trailing: Text("12"),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.directions_bus),
                    title: Text("Bus Number"),
                    trailing: Text("TS09 AB 1234"),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.water_drop),
                    title: Text("Blood Group"),
                    trailing: Text("O+"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Parent Name"),
                    trailing: Text("Ibrahim"),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text("Phone"),
                    trailing: Text("9876543210"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 35),
                          SizedBox(height: 8),
                          Text("Attendance"),
                          Text(
                            "95%",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    Card(
                      child: InkWell(
                        onTap: () {},
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_bus,
                                size: 40, color: Colors.blue),
                            SizedBox(height: 10),
                            Text(
                              "Track Bus",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Card(
                      child: InkWell(
                        onTap: () {},
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bar_chart,
                                size: 40, color: Colors.green),
                            SizedBox(height: 10),
                            Text(
                              "Results",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Card(
                      child: InkWell(
                        onTap: () {},
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications,
                                size: 40, color: Colors.orange),
                            SizedBox(height: 10),
                            Text(
                              "Notices",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Card(
                      child: InkWell(
                        onTap: () {},
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.book,
                                size: 40, color: Colors.purple),
                            SizedBox(height: 10),
                            Text(
                              "Homework",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.assignment,
                              color: Colors.orange, size: 35),
                          SizedBox(height: 8),
                          Text("Homework"),
                          Text(
                            "3",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}