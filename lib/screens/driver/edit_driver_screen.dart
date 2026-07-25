import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class EditDriverScreen extends StatefulWidget {
  final String driverId;
  final Map<String, dynamic> driverData;

  const EditDriverScreen({
    super.key,
    required this.driverId,
    required this.driverData,
  });

  @override
  State<EditDriverScreen> createState() => _EditDriverScreenState();
}

class _EditDriverScreenState extends State<EditDriverScreen> {
  final FirestoreService firestoreService = FirestoreService();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController licenseController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.driverData["name"]);

    phoneController =
        TextEditingController(text: widget.driverData["phone"]);

    emailController =
        TextEditingController(text: widget.driverData["email"]);

    licenseController =
        TextEditingController(text: widget.driverData["licenseNumber"]);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    licenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Driver"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Driver Name",
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
              controller: licenseController,
              decoration: const InputDecoration(
                labelText: "License Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await firestoreService.updateDriver(
                    driverId: widget.driverId,
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    email: emailController.text.trim(),
                    licenseNumber: licenseController.text.trim(),
                  );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Driver Updated Successfully"),
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}