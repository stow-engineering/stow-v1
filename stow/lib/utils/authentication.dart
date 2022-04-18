import 'package:firebase_auth/firebase_auth.dart';

import 'firebase.dart';
import '../models/user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  StowUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return StowUser(user.uid, user.email);
  }

  Stream<StowUser?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  User get myUser {
    return _firebaseAuth.currentUser;
  }

  Future<StowUser?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(cred.user);
  }

  Future<StowUser?> createUserWithEmailPassword(
      String email, String password, String firstName, String lastName) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    await FirebaseService(cred.user.uid)
        .updateUserData(cred.user.email, firstName, lastName);
    return _userFromFirebase(cred.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
