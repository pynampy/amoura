import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uid/uid.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signup(String email, String password) async {
    final user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user;
  }

  Future<void> createUserInFirestore({
    required String name,
    required String email,
    required String uid,
  }) async {
    var coupleId = UId.getId();
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'coupleId': coupleId,
    });

    await createCoupleInFirestore(coupleId);
  }

  Future<void> createCoupleInFirestore(String coupleId) async {
    await FirebaseFirestore.instance.collection('couples').doc(coupleId).set({
      'coupleId': coupleId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> isLoggedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  User? getCurrentUser() => _firebaseAuth.currentUser;
}
