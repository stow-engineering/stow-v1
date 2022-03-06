import 'package:firebase_auth/firebase_auth.dart';
import 'package:stow/database.dart';
import 'user.dart';

class AuthService {
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
    String email,
    String password,
  ) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    await DatabaseService(cred.user.uid).updateUserData(cred.user.email);
    return _userFromFirebase(cred.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
