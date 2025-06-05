import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  Future<UserCredential> signIn(
    String email, 
    String password
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } catch (e) {
      rethrow; 
    }
  }

  Future<UserCredential> signUp(
    String email,
    String password
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
  } 

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}