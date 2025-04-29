
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseExpenseAPI {
//   static final FirebaseFirestore db = FirebaseFirestore.instance;
//   final User? user = FirebaseAuth.instance.currentUser;

//   Future<String> addExpense(Map<String, dynamic> expense, Map<String, dynamic> json) async {
//     try {
//       await db.collection("expenses").add({
//         ...expense,
//         'userId': user?.uid,
//       });
//       return "Successfully added expense!";
//     } on FirebaseException catch (e) {
//       return "Failed with error '${e.code}: ${e.message}';";
//     }
//   }

//   Future<String> deleteExpense(String id) async {
//     try {
//       await db.collection("expenses").doc(id).delete();
//       return "Successfully deleted expense!";
//     } on FirebaseException catch (e) {
//       return "Failed with error '${e.code}: ${e.message}';";
//     }
//   }

//   Future<String> editExpense(String id, Map<String, dynamic> updatedData) async {
//     try {
//       await db.collection("expenses").doc(id).update(updatedData);
//       return "Successfully updated expense!";
//     } on FirebaseException catch (e) {
//       return "Failed with error '${e.code}: ${e.message}';";
//     }
//   }

//   Stream<QuerySnapshot> getAllExpenses() {
//     return db
//         .collection("expenses")
//         .where('userId', isEqualTo: user?.uid)
//         .snapshots();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseExpenseAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addExpense(String userId, Map<String, dynamic> expenseData) async {
    try {
      await db.collection("expenses").add({
        ...expenseData,
        'userId': userId,
      });
      return "Successfully added expense!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> deleteExpense(String id) async {
    try {
      await db.collection("expenses").doc(id).delete();
      return "Successfully deleted expense!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editExpense(String id, Map<String, dynamic> updatedData) async {
    try {
      await db.collection("expenses").doc(id).update(updatedData);
      return "Successfully updated expense!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getExpensesByUserId(String userId) {
    return db
        .collection("expenses")
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> clearAllExpensesForUser(String userId) async {
    // This is optional - only use if you want to actually delete data on sign-out
    // Otherwise, just clearing the local cache is sufficient
    final snapshot = await db.collection("expenses")
        .where('userId', isEqualTo: userId)
        .get();
    
    final batch = db.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}