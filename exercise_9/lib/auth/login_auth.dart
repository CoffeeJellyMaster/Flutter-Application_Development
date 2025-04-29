
import 'package:firebase_auth/firebase_auth.dart';

class LoginAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ✅ Added function: enable persistence if "keep me signed in" is checked
  Future<void> setPersistence({required bool keepSignedIn}) async {
    try {
      await _auth.setPersistence(
        keepSignedIn
            ? Persistence.LOCAL // persist even when app is closed
            : Persistence.SESSION, // session only
      );
    } catch (e) {
      print("Error setting persistence: $e");
    }
  }
}
