import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Update Bus Location
  Future<void> updateBusLocation({
    required String busId,
    required String busNumber,
    required String driverName,
    required double latitude,
    required double longitude,
    required String status,
  }) async {
    await _firestore.collection('buses').doc(busId).set({
      'busNumber': busNumber,
      'driverName': driverName,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> addStudent({
    required String studentId,
    required String name,
    required String className,
    required String busId,
    required String parentId,
  }) async {
    await _firestore.collection('students').doc(studentId).set({
      'name': name,
      'className': className,
      'busId': busId,
      'parentId': parentId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get Single Bus Live Location
  Stream<DocumentSnapshot<Map<String, dynamic>>> getBusLocation(
      String busId) {
    return _firestore.collection('buses').doc(busId).snapshots();
  }

  // Get All Buses
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllBuses() {
    return _firestore.collection('buses').snapshots();
  }

// Get All Students
  Stream<QuerySnapshot<Map<String, dynamic>>> getStudents() {
    return _firestore.collection('students').snapshots();
  }

  Future<void> deleteStudent(String studentId) async {
    await _firestore.collection('students').doc(studentId).delete();
  }
}