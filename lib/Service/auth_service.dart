import 'package:chat_bot_app/Service/auth_service.dart' as _auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   Stream<User?> get userChanges => _auth.authStateChanges();

  Future<User?> signUp(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'name': name,
        });
        return user;
      }
    } catch (e) {
      print('SignUp error: $e');
      rethrow;
    }
    return null;
  }

  // ✅ Login
   Future<User?> logIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('SignIn error: $e');
      rethrow;
    }
  }
   // ✅ Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> isUserLoggedIn() async {
    return _auth.currentUser != null;
  }
   User? getCurrentUser() {
    return _auth.currentUser;
  }
}
 
  
