
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseAccountsAPI {
//   static final FirebaseFirestore db = FirebaseFirestore.instance;
//   static final FirebaseAuth auth = FirebaseAuth.instance;

//   Future<String> createAccountWithEmail({
//     required String email,
//     required String password,
//     required String firstName,
//     required String lastName,
//   }) async {
//     try {
//       // Create user in Firebase Authentication
//       UserCredential userCredential = await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       if (userCredential.user == null) {
//         return "Failed to create user - no user returned";
//       }

//       // Store additional user data in Firestore (excluding password)
//       await db.collection("Users").doc(userCredential.user!.uid).set({
//         'firstName': firstName,
//         'lastName': lastName,
//         'email': email,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       return "Successfully created account!";
//     } on FirebaseAuthException catch (e) {
//       return "Firebase Auth Error: ${e.code}: ${e.message}";
//     } on FirebaseException catch (e) {
//       return "Firestore Error: ${e.code}: ${e.message}";
//     } catch (e) {
//       return "Unexpected error: $e";
//     }
//   }

//   Future<bool> emailExists(String email) async {
//     try {
//       var result = await db
//           .collection("Users")
//           .where("email", isEqualTo: email)
//           .limit(1)
//           .get();
//       return result.docs.isNotEmpty;
//     } catch (e) {
//       print("Error checking email existence: $e");
//       return false;
//     }
//   }

//   Future<Map<String, dynamic>?> getUserData(String uid) async {
//     try {
//       DocumentSnapshot doc = await db.collection("Users").doc(uid).get();
//       if (doc.exists) {
//         return doc.data() as Map<String, dynamic>?;
//       }
//       return null;
//     } catch (e) {
//       print("Error getting user data: $e");
//       return null;
//     }
//   }
// }

// accounts_api.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAccountsAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> createAccountWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return "Failed to create user - no user returned";
      }

      // Store additional user data in Firestore (excluding password)
      await db.collection("Users").doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return "Successfully created account!";
    } on FirebaseAuthException catch (e) {
      return "Firebase Auth Error: ${e.code}: ${e.message}";
    } on FirebaseException catch (e) {
      return "Firestore Error: ${e.code}: ${e.message}";
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

  Future<bool> emailExists(String email) async {
    try {
      var result = await db
          .collection("Users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();
      return result.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email existence: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await db.collection("Users").doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }
}