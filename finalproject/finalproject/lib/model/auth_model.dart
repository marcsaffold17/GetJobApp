import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return false;
      }
      throw Exception("Login failed: ${e.message}");
    }
  }

  Future<void> createAccount(
    String email,
    String password,
    String username,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );

      await FirebaseFirestore.instance.collection('Login-Info').doc(email).set({
        'username': username,
        'email': email.trim(),
      });
    } catch (e) {
      throw Exception("Account creation failed: ${e.toString()}");
    }
  }
}
