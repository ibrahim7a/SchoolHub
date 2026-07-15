import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';
import 'add_fee_screen.dart';

class FeesScreen extends StatelessWidget {
  FeesScreen({super.key});

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fees Management"),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddFeeScreen(),
            ),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getFees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Fee Records",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final fees = snapshot.data!.docs;

          return ListView.builder(
            itemCount: fees.length,
            itemBuilder: (context, index) {
              final fee = fees[index].data();

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: fee['status'] == "Paid"
                        ? Colors.green
                        : Colors.red,
                    child: const Icon(
                      Icons.currency_rupee,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(fee['studentName']),
                  subtitle: Text(
                    "Total: ₹${fee['totalFee']}\n"
                        "Paid: ₹${fee['paidFee']}\n"
                        "Remaining: ₹${fee['remainingFee']}",
                  ),
                  trailing: Text(
                    fee['status'],
                    style: TextStyle(
                      color: fee['status'] == "Paid"
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
    );
  }
}