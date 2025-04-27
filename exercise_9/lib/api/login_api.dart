// import 'package:firebase_auth/firebase_auth.dart';

// class LoginAPI {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<String> loginUser(String email, String password) async {
//     try {
//       await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       return "Successfully logged in!";
//     } on FirebaseAuthException catch (e) {
//       return "Failed with error '${e.code}: ${e.message}";
//     }
//   }

//   Future<void> logoutUser() async {
//     await _auth.signOut();
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';

class LoginAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Successfully logged in!";
    } on FirebaseAuthException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  // ✅ Added helper function to check if already logged in
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }
}
