import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<UserCredential> createTeacher({
    required String email,
    required String password,
  }) async {
    final app = await Firebase.initializeApp(
      name: 'teacherAuthApp',
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final secondaryAuth = FirebaseAuth.instanceFor(app: app);

    try {
      return await secondaryAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } finally {
      await app.delete();
    }
  }

  Future<UserCredential> createDriver({
    required String email,
    required String password,
  }) async {
    final app = await Firebase.initializeApp(
      name: 'driverAuthApp',
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final secondaryAuth = FirebaseAuth.instanceFor(app: app);

    try {
      return await secondaryAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } finally {
      await app.delete();
    }
  }

  Future<UserCredential> createUserAccount({
    required String email,
    required String password,
  }) async {
    final app = await Firebase.initializeApp(
      name: 'userAuthApp',
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final secondaryAuth = FirebaseAuth.instanceFor(app: app);

    try {
      return await secondaryAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } finally {
      await app.delete();
    }
  }

  Future<String?> getUserRole(User user) async {
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

    final teacherQuery = await _firestore
        .collection('teachers')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (teacherQuery.docs.isNotEmpty) {
      return 'teacher';
    }

    final parentQuery = await _firestore
        .collection('parents')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (parentQuery.docs.isNotEmpty) {
      return 'parent';
    }

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

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}