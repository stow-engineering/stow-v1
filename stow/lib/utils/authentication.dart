import 'package:firebase_auth/firebase_auth.dart';
import 'firebase.dart';
import '../models/user.dart';

/// AuthenticationService Class: user registration, login
class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Utilities
  StowUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return StowUser(user.uid, user.email);
  }

  Stream<StowUser?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  User? get myUser {
    return _firebaseAuth.currentUser;
  }

  /// Sign-in
  Future<StowUser?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(cred.user);
  }

  /// Create User
  Future<StowUser?> createUserWithEmailPassword(
      String email, String password, String firstName, String lastName) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (cred.user?.uid != null) {
      String userUid = cred.user?.uid ?? "";
      String userEmail = cred.user?.email ?? "";
      await FirebaseService(userUid)
          .updateUserData(userEmail, firstName, lastName);
      return _userFromFirebase(cred.user);
    }

    return null;
  }

  /// Reset Password
  Future<StowUser?> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Sign-out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
