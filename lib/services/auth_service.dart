import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================= LOGIN =================

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // ================= TEACHER ACCOUNT =================

  Future<UserCredential> createTeacher({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // ================= DRIVER ACCOUNT =================

  Future<UserCredential> createDriver({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // ================= GENERAL USER ACCOUNT =================

  Future<UserCredential> createUserAccount({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // ================= GET USER ROLE =================

  Future<String?> getUserRole(User user) async {
    // First check professional users collection
    final userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      final data = userDoc.data();

      if (data != null && data['role'] != null) {
        return data['role'].toString();
      }
    }

    // ================= OLD TEACHER DATA =================

    final teacherQuery = await _firestore
        .collection('teachers')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (teacherQuery.docs.isNotEmpty) {
      return 'teacher';
    }

    // ================= OLD PARENT DATA =================

    final parentQuery = await _firestore
        .collection('parents')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (parentQuery.docs.isNotEmpty) {
      return 'parent';
    }

    // ================= OLD DRIVER DATA =================

    final driverQuery = await _firestore
        .collection('drivers')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (driverQuery.docs.isNotEmpty) {
      return 'driver';
    }

    return null;
  }

  // ================= CREATE USER PROFILE =================

  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    required String role,
    String schoolId = 'school_001',
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'schoolId': schoolId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ================= SIGN OUT =================

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ================= CURRENT USER =================

  User? get currentUser => _auth.currentUser;
}