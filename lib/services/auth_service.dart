import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get current user stream
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // SIGN UP with email verification
  Future<User?> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile in Firestore
      if (result.user != null) {
        await _db.collection('users').doc(result.user!.uid).set({
          'email': email,
          'displayName': email.split('@')[0],
          'createdAt': FieldValue.serverTimestamp(),
          'emailVerified': false,
          'notificationsEnabled': true,
        });

        // Send email verification
        await result.user!.sendEmailVerification();
      }

      return result.user;
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }

  // LOGIN
  Future<User?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Check if email is verified
  bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Reload user to check email verification status
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  // Resend verification email
  Future<void> resendVerificationEmail() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print('Error resending verification email: $e');
      rethrow;
    }
  }

  // Get user profile from Firestore
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Update notification preferences
  Future<void> updateNotificationPreference(String uid, bool enabled) async {
    try {
      await _db.collection('users').doc(uid).update({
        'notificationsEnabled': enabled,
      });
    } catch (e) {
      print('Error updating notification preference: $e');
      rethrow;
    }
  }
}
