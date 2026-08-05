
import "package:firebase_auth/firebase_auth.dart";


class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password,
      );
  }

  //Create user with email and password
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //sign in with google (credential)
  Future<void> signInWithCredential({
    required OAuthCredential credential
  }) async {
    await _firebaseAuth.signInWithCredential(credential);}
  
  //sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

}
