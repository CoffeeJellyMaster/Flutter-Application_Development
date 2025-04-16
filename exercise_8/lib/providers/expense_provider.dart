import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/expense_api.dart';
import '../models/expense_model.dart';

class ExpenseListProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _expenseStream;
  late FirebaseExpenseAPI firebaseService;

  ExpenseListProvider() {
    firebaseService = FirebaseExpenseAPI();
    fetchExpenses();
  }

  Stream<QuerySnapshot> get expenses => _expenseStream;

  void fetchExpenses() {
    _expenseStream = firebaseService.getAllExpenses();
  }

  Future<void> addExpense(Expense item) async {
    try {
      String message = await firebaseService.addExpense(item.toJson());
      print("Add: $message");
    } catch (e) {
      print("Error adding expense: $e");
    }
  }

  Future<void> editExpense(String id, Expense updated) async {
    try {
      String message = await firebaseService.editExpense(id, updated.toJson());
      print("Edit: $message");
    } catch (e) {
      print("Error editing expense: $e");
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      String message = await firebaseService.deleteExpense(id);
      print("Delete: $message");
    } catch (e) {
      print("Error deleting expense: $e");
    }
  }
}
