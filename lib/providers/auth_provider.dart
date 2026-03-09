import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser ?? _auth.currentUser;
  String get userId => currentUser?.uid ?? '';
  String? get userEmail => currentUser?.email;
  bool get isLoggedIn => currentUser != null;
  bool get isLoading => _isLoading;
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  AuthProvider() {
    _currentUser = _auth.currentUser;
    // Listen to auth state changes
    _auth.authStateChanges().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  /// Sign up with email and password
  Future<bool> signUp(String email, String password, String displayName) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(displayName);
      await userCredential.user?.sendEmailVerification();

      // Create user profile in Firestore
      await _firestoreService.createUserProfile(
        uid: userCredential.user!.uid,
        email: email,
        displayName: displayName,
      );

      _currentUser = userCredential.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Sign up error: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = userCredential.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.signOut();
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh user data from Firebase
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      _currentUser = _auth.currentUser;
      notifyListeners();
    } catch (e) {
      print('Reload user error: $e');
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print('Send email verification error: $e');
      rethrow;
    }
  }

  /// Resend email verification link
  Future<void> resendVerificationEmail() async {
    try {
      if (_auth.currentUser != null && !_auth.currentUser!.emailVerified) {
        await _auth.currentUser!.sendEmailVerification();
      }
    } catch (e) {
      print('Resend verification error: $e');
      rethrow;
    }
  }

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
