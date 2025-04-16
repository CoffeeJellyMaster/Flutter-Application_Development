import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseExpenseAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addExpense(Map<String, dynamic> expense) async {
    try {
      await db.collection("expenses").add(expense);
      return "Successfully added expense!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}';";
    }
  }

  Future<String> deleteExpense(String id) async {
    try {
      await db.collection("expenses").doc(id).delete();
      return "Successfully deleted expense!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}';";
    }
  }

  Future<String> editExpense(String id, Map<String, dynamic> updatedData) async {
    try {
      await db.collection("expenses").doc(id).update(updatedData);
      return "Successfully updated expense!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}';";
    }
  }

  Stream<QuerySnapshot> getAllExpenses() {
    return db.collection("expenses").snapshots();
  }
}
