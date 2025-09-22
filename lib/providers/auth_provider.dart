import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;
  bool get isSignedIn => user != null;

  AuthProvider() {
    // Listen to auth state changes and notify listeners
    _auth.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  /// 🔹 Sign in with Email/Password
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Email sign-in failed");
    }
  }

  /// 🔹 Sign up with Email/Password
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Email sign-up failed");
    }
  }

  /// 🔹 Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Sign out failed: $e");
    }
  }
}
