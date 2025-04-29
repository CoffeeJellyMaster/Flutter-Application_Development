
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../api/expense_api.dart';
// import '../models/expense_model.dart';

// class ExpenseListProvider with ChangeNotifier {
//   late Stream<QuerySnapshot> _expenseStream;
//   late FirebaseExpenseAPI firebaseService;
//   User? _currentUser;

//   ExpenseListProvider() {
//     _currentUser = FirebaseAuth.instance.currentUser;
//     firebaseService = FirebaseExpenseAPI();
//     fetchExpenses();
//   }

//   Stream<QuerySnapshot> get expenses => _expenseStream;

//   void fetchExpenses() {
//     _expenseStream = firebaseService.getAllExpenses();
//     notifyListeners();
//   }

//   Future<void> addExpense(Expense item) async {
//     try {
//       String message = await firebaseService.addExpense(item.toJson());
//       print("Add: $message");
//       notifyListeners();
//     } catch (e) {
//       print("Error adding expense: $e");
//     }
//   }

//   Future<void> editExpense(String id, Expense updated) async {
//     try {
//       String message = await firebaseService.editExpense(id, updated.toJson());
//       print("Edit: $message");
//       notifyListeners();
//     } catch (e) {
//       print("Error editing expense: $e");
//     }
//   }

//   Future<void> deleteExpense(String id) async {
//     try {
//       String message = await firebaseService.deleteExpense(id);
//       print("Delete: $message");
//       notifyListeners();
//     } catch (e) {
//       print("Error deleting expense: $e");
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/expense_api.dart';
import '../models/expense_model.dart';

class ExpenseListProvider with ChangeNotifier {
  final FirebaseExpenseAPI _api = FirebaseExpenseAPI();
  User? _currentUser;
  List<Expense> _expenses = [];
  Stream<QuerySnapshot>? _expenseStream;

  ExpenseListProvider() {
    _currentUser = FirebaseAuth.instance.currentUser;
    _setupAuthListener();
  }

  List<Expense> get expenses => _expenses;

  void _setupAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != _currentUser) {
        _currentUser = user;
        if (user != null) {
          _fetchExpenses(user.uid);
        } else {
          _clearAllExpenses();
        }
      }
    });
  }

  void _fetchExpenses(String userId) {
    _expenseStream = _api.getExpensesByUserId(userId);
    _expenseStream?.listen((QuerySnapshot snapshot) {
      _expenses = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Expense.fromJson(data, doc.id);
      }).toList();
      notifyListeners();
    });
  }

  Future<void> _clearAllExpenses() async {
    if (_currentUser != null) {
      // Optional: Uncomment if you want to actually delete data from Firestore
      // await _api.clearAllExpensesForUser(_currentUser!.uid);
    }
    _expenses = [];
    _expenseStream = null;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    if (_currentUser == null) return;
    await _api.addExpense(_currentUser!.uid, expense.toJson());
    notifyListeners();
  }

  Future<void> editExpense(String id, Expense updated) async {
    await _api.editExpense(id, updated.toJson());
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    await _api.deleteExpense(id);
    notifyListeners();
  }

  Future<void> clearExpensesOnSignOut() async {
    await _clearAllExpenses();
  }
}