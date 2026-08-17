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

  Future<void> deleteBus(String busId) async {
    await _firestore.collection('buses').doc(busId).delete();
  }

  Future<void> addStudent({
    required String studentId,
    required String name,
    required String className,
    required String busId,
    required String parentId,
  }) async {
    await _firestore.collection('students').doc(studentId).set({
      'studentId' : studentId,
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
    required String email,
  }) async {
    print("Before Firestore");

    await _firestore.collection('drivers').doc(driverId).set({
      'name': name,
      'phone': phone,
      'licenseNumber': licenseNumber,
      'email': email,
      'assignedBusId': '',
      'status': 'Offline',
      'createdAt': FieldValue.serverTimestamp(),
    });

    print("After Firestore");
  }

  Future<void> addHomework({
    required String subject,
    required String title,
    required String description,
    required String dueDate,
    required String className,
  }) async {
    await _firestore.collection('homework').add({
      'subject': subject,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'className': className,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> assignBusToDriver({
    required String driverId,
    required String busId,
  }) async {
    await _firestore.collection('drivers').doc(driverId).update({
      'assignedBusId': busId,
    });
  }

  Future<void> updateBusDriver({
    required String busId,
    required String driverName,
  }) async {
    await _firestore.collection('buses').doc(busId).update({
      'driverName': driverName,
    });
  }

  // ================= PARENTS =================

  Future<void> addParent({
    required String parentId,
    required String name,
    required String email,
    required String phone,
    required String address,
    required String className,
  }) async {
    await _firestore.collection('parents').doc(parentId).set({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'createdAt': FieldValue.serverTimestamp(),
      'className': className,
    });
  }

  Future<void> updateStudent({
    required String studentId,
    required String name,
    required String className,
    required String busId,
    required String parentId,
  }) async {
    await _firestore.collection('students').doc(studentId).update({
      'name': name,
      'className': className,
      'busId': busId,
      'parentId': parentId,
    });
  }

  Future<void> updateParent({
    required String parentId,
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    await _firestore.collection('parents').doc(parentId).update({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    });
  }

  Future<void> deleteParent(String parentId) async {
    await _firestore.collection('parents').doc(parentId).delete();
  }

  Future<void> assignDriverToBus({
    required String driverId,
    required String driverName,
    required String busId,
  }) async {
    await _firestore.collection('drivers').doc(driverId).update({
      'assignedBusId': busId,
    });

    await _firestore.collection('buses').doc(busId).update({
      'driverName': driverName,
    });
  }

  Future<void> markAttendance({
    required String studentId,
    required String studentName,
    required String className,
    required bool isPresent,
  }) async {
    final DateTime now = DateTime.now();

    final String dateKey =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final String attendanceId =
        "${studentId}_$dateKey";

    await _firestore
        .collection('attendance')
        .doc(attendanceId)
        .set({
      'studentId': studentId,
      'studentName': studentName,
      'className': className,
      'isPresent': isPresent,
      'date': Timestamp.fromDate(now),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addFee({
    required String studentId,
    required String studentName,
    required double totalFee,
    required double paidFee,
  }) async {
    await _firestore.collection('fees').doc(studentId).set({
      'studentName': studentName,
      'totalFee': totalFee,
      'paidFee': paidFee,
      'remainingFee': totalFee - paidFee,
      'status': paidFee >= totalFee ? 'Paid' : 'Pending',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= RESULTS =================

  Future<void> addResult({
    required String studentId,
    required String studentName,
    required String className,
    required String subject,
    required double marks,
    required double totalMarks,
  }) async {
    final percentage = (marks / totalMarks) * 100;
    String grade;

    if (percentage >= 90) {
      grade = "A+";
    } else if (percentage >= 80) {
      grade = "A";
    } else if (percentage >= 70) {
      grade = "B";
    } else if (percentage >= 60) {
      grade = "C";
    } else if (percentage >= 50) {
      grade = "D";
    } else {
      grade = "F";
    }

    await _firestore.collection("results").add({
      "studentId": studentId,
      "studentName": studentName,
      "className": className,
      "subject": subject,
      "marks": marks,
      "totalMarks": totalMarks,
      "percentage": percentage,
      "grade": grade,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteResult(String resultId) async {
    await _firestore.collection("results").doc(resultId).delete();
  }

  Future<void> updateBus({
    required String busId,
    required String busNumber,
    required int capacity,
  }) async {
    await _firestore.collection('buses').doc(busId).update({
      'busNumber': busNumber,
      'capacity': capacity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= TEACHERS =================

  Future<void> addTeacher({
    required String teacherId,
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String className,
  }) async {
    await _firestore.collection("teachers").doc(teacherId).set({
      "name": name,
      "email": email,
      "phone": phone,
      "subject": subject,
      "className": className,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTeacher({
    required String teacherId,
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String className,
  }) async {
    await _firestore.collection("teachers").doc(teacherId).update({
      "name": name,
      "email": email,
      "phone": phone,
      "subject": subject,
      "className": className,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTeachers() {
    return _firestore
        .collection("teachers")
        .orderBy("name")
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getTeacher(
      String teacherId) async {
    return await _firestore
        .collection("teachers")
        .doc(teacherId)
        .get();
  }

  Future<void> deleteTeacher(String teacherId) async {
    await _firestore.collection("teachers").doc(teacherId).delete();
  }

  // Fixed: Corrected return type signature from QuerySnapshot to DocumentSnapshot
  Future<DocumentSnapshot<Map<String, dynamic>>> getParent(String parentId) async {
    return await _firestore.collection('parents').doc(parentId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getBusById(String busId) async {
    return await _firestore.collection('buses').doc(busId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getParentById(String parentId) async {
    return await _firestore.collection('parents').doc(parentId).get();
  }

  // ================= CLASSES =================

  Future<void> addClass({
    required String className,
    required String section,
  }) async {
    await _firestore.collection("classes").add({
      "className": className,
      "section": section,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getClasses() {
    return _firestore
        .collection("classes")
        .orderBy("className")
        .snapshots();
  }

  Future<void> deleteClass(String classId) async {
    await _firestore.collection("classes").doc(classId).delete();
  }

  Future<void> updateClass({
    required String classId,
    required String className,
    required String section,
  }) async {
    await _firestore.collection("classes").doc(classId).update({
      "className": className,
      "section": section,
    });
  }

  Future<void> updateDriver({
    required String driverId,
    required String name,
    required String phone,
    required String email,
    required String licenseNumber,
  }) async {
    await _firestore.collection("drivers").doc(driverId).update({
      "name": name,
      "phone": phone,
      "email": email,
      "licenseNumber": licenseNumber,
    });
  }

  // Get Single Bus Live Location
  Stream<DocumentSnapshot<Map<String, dynamic>>> getBusLocation(String busId) {
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentsByClass(String className) {

    print("Searching for class: '$className'");

    return _firestore
        .collection('students')
        .where('className', isEqualTo: className.trim())
        .snapshots();
  }

  Future<void> deleteStudent(String studentId) async {
    await _firestore.collection('students').doc(studentId).delete();
  }

  Future<void> deleteDriver(String driverId) async {
    await _firestore.collection('drivers').doc(driverId).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBuses() {
    return _firestore.collection('buses').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDrivers() {
    return _firestore.collection('drivers').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getHomework() {
    return _firestore.collection('homework').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getHomeworkSubjects() {
    return _firestore.collection('teachers').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFees() {
    return _firestore.collection('fees').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentsForDropdown() {
    return _firestore.collection('students').orderBy('name').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBusDropdown() {
    return _firestore.collection('buses').orderBy('busNumber').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentsOrdered() {
    return _firestore.collection('students').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getResults() {
    return _firestore
        .collection('results')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentsByParent(String parentId) {
    return _firestore
        .collection('students')
        .where('parentId', isEqualTo: parentId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getHomeworkByClass(String className) {
    return _firestore
        .collection("homework")
        .where("className", isEqualTo: className)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAttendanceByStudent(String studentId) {
    return _firestore
        .collection("attendance")
        .where("studentId", isEqualTo: studentId)
        .orderBy("date", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getParentsDropdown() {
    return _firestore.collection('parents').orderBy('name').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getParents() {
    return _firestore.collection('parents').orderBy('name').snapshots();
  }

  // Fixed: Corrected return type signature from QuerySnapshot to DocumentSnapshot
  Stream<DocumentSnapshot<Map<String, dynamic>>> getBus(String busId) {
    return _firestore.collection('buses').doc(busId).snapshots();
  }
}