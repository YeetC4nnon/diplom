import 'package:firebase_auth/firebase_auth.dart';
import 'package:rs_booking/objects/user.dart';

class AuthorizationService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<Users?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      return Users.fromFirebase(user);
    } on FirebaseException catch (error) {
      return null;
    }
  }

  Future<Users?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      return Users.fromFirebase(user);
    } on FirebaseException catch (error) {
      return null;
    }
  }

  Future logout() async {
    await _fAuth.signOut();
  }

  Stream<Users?> get currentUser {
    return _fAuth
        .authStateChanges()
        .map((User? user) => user != null ? Users.fromFirebase(user) : null);
  }
}
