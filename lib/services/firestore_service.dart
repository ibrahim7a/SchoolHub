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

  Future<void> addBus({
    required String busId,
    required String busNumber,
    required String driverName,
    required int capacity,
  }) async {
    await _firestore.collection('buses').doc(busId).set({
      'busNumber': busNumber,
      'driverName': driverName,
      'capacity': capacity,
      'status': 'Offline',
      'latitude': 0.0,
      'longitude': 0.0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addDriver({
    required String driverId,
    required String name,
    required String phone,
    required String licenseNumber,
  }) async {
    print("Before Firestores");

    await _firestore.collection('drivers').doc(driverId).set({
      'name': name,
      'phone': phone,
      'licenseNumber': licenseNumber,
      'assignedBusId': '',
      'status': 'Offline',
      'createdAt': FieldValue.serverTimestamp(),
    });

    print("After Firestore");
  }

  Future<void> assignBusToDriver({
    required String driverId,
    required String busId,
}) async {
    await _firestore.collection('drivers').doc(driverId).update({'assignedBusId': busId,
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getBuses() {
    return _firestore.collection('buses').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDrivers() {
    return _firestore.collection('drivers').snapshots();
  }
}