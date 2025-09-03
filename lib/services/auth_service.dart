import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tree_care/authentication/login_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("users");

  // Register user with email and password
  Future<User?> registerUser(
      {required String fullName,
      required String username,
      required String email,
      required String password}) async {
    try {
      // Check username exists
      final snapshot =
          await _dbRef.orderByChild("username").equalTo(username).get();

      if (snapshot.exists) {
        throw Exception("Username already taken");
      }

      // Create user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _dbRef.child(user.uid).set({
          "uid": user.uid,
          "fullName": fullName,
          "username": username,
          "email": email,
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Login user with username and password
  Future<User?> loginWithUsername(String username, String password) async {
    try {
      // Find email by username in Realtime Database
      DatabaseEvent event =
          await _dbRef.orderByChild("username").equalTo(username).once();

      if (event.snapshot.value == null) {
        throw Exception("Username not found");
      }

      // Take email from the snapshot
      Map data = (event.snapshot.value as Map);
      var firstUser = data.values.first as Map;
      String email = firstUser["email"];

      // Login with email and password in Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Edit fullName
  Future<void> editFullName(String newFullName) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception("No user logged in");

      // Update in Realtime Database
      await _dbRef.child(user.uid).update({
        "fullName": newFullName,
      });

      // Optional: Update display name in Firebase Auth profile
      await user.updateDisplayName(newFullName);
      await user.reload();
    } catch (e) {
      throw Exception("Failed to update full name: $e");
    }
  }

  // Logout
  Future<void> logOut(BuildContext context) async {
    try {
      await _auth.signOut();

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception("No user logged in");
      }

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
      await _auth.currentUser?.reload();

      // Logout after password change
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Change password failed");
    }
  }
}
