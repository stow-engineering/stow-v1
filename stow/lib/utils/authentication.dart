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

  User? get myUser {
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

    if (cred.user?.uid != null) {
      String userUid = cred.user?.uid ?? "";
      String userEmail = cred.user?.email ?? "";
      await FirebaseService(userUid)
          .updateUserData(userEmail, firstName, lastName);
      return _userFromFirebase(cred.user);
    }

    return null;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
