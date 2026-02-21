

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<UserCredential> signup(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> saveUser(AppUser user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  Future<AppUser?> currentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final snap = await _db.collection('users').doc(user.uid).get();
    if (!snap.exists) return null;

    return AppUser.fromMap(snap.id, snap.data()!);
  }

  Future<void> logout() => _auth.signOut();
}