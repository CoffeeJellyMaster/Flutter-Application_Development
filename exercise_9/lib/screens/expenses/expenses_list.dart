
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/login_provider.dart';
// import '../../providers/accounts_provider.dart';
// import 'expenses_form.dart';
// import 'edit_expense.dart';
// import '../../models/expense_model.dart';
// import '../../providers/expense_provider.dart';
// import '../accounts/account_landing.dart';

// class ExpensesList extends StatefulWidget {
//   const ExpensesList({super.key});

//   @override
//   State<ExpensesList> createState() => _ExpensesListState();
// }

// class _ExpensesListState extends State<ExpensesList> {
//   Map<String, String>? _userNames;
//   bool _isLoadingNames = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserNames();
//   }

//   Future<void> _loadUserNames() async {
//     final accountsProvider = Provider.of<AccountsProvider>(context, listen: false);
//     final names = await accountsProvider.getUserNames(accountsProvider.currentUser?.uid ?? '');
//     setState(() {
//       _userNames = names;
//       _isLoadingNames = false;
//     });
//   }

//   Future<void> _signOutAndNavigate(BuildContext context, LoginProvider loginProvider) async {
//     final expenseProvider = Provider.of<ExpenseListProvider>(context, listen: false);
//     await expenseProvider.clearExpensesOnSignOut();
//     await loginProvider.logout();
    
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const AccountLandingPage()),
//       (Route<dynamic> route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loginProvider = Provider.of<LoginProvider>(context, listen: false);
//     final expenseProvider = Provider.of<ExpenseListProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.green[800],
//         title: _isLoadingNames
//             ? const Text('Loading...', style: TextStyle(color: Colors.white))
//             : Text(
//                 '${_userNames?['firstName'] ?? 'Unknown'} ${_userNames?['lastName'] ?? 'User'}',
//                 style: const TextStyle(color: Colors.white),
//               ),
//         actions: [
//           TextButton.icon(
//             onPressed: () => _signOutAndNavigate(context, loginProvider),
//             icon: const Icon(Icons.logout, color: Colors.white),
//             label: const Text(
//               'Sign Out',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       body: expenseProvider.expenses.isEmpty
//           ? const Center(child: Text("No expenses found"))
//           : ListView.builder(
//               itemCount: expenseProvider.expenses.length,
//               itemBuilder: (context, index) {
//                 final expense = expenseProvider.expenses[index];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: expense.isPaid ? Colors.green : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(4.0),
//                     ),
//                     child: Row(
//                       children: [
//                         Checkbox(
//                           value: expense.isPaid,
//                           onChanged: (value) async {
//                             final updated = Expense(
//                               id: expense.id,
//                               name: expense.name,
//                               description: expense.description,
//                               category: expense.category,
//                               amount: expense.amount,
//                               isPaid: value ?? false,
//                             );
//                             await expenseProvider.editExpense(expense.id!, updated);
//                           },
//                           checkColor: Colors.white,
//                           activeColor: Colors.green[800],
//                         ),
//                         Expanded(
//                           child: InkWell(
//                             onTap: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => EditExpense(expense: expense),
//                               ),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 16.0),
//                               child: Text(
//                                 expense.name,
//                                 style: TextStyle(
//                                   color: expense.isPaid ? Colors.white : Colors.black,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete),
//                           color: Colors.red,
//                           onPressed: () => expenseProvider.deleteExpense(expense.id!),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const ExpensesForm()),
//         ),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/login_provider.dart';
import '../../providers/accounts_provider.dart';
import 'expenses_form.dart';
import 'edit_expense.dart';
import '../../models/expense_model.dart';
import '../../providers/expense_provider.dart';
import '../accounts/account_landing.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({super.key});

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  Map<String, String>? _userNames;
  bool _isLoadingNames = true;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    final accountsProvider = Provider.of<AccountsProvider>(context, listen: false);
    
    // Wait for the current user to be loaded
    if (accountsProvider.currentUser == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (accountsProvider.currentUser != null) {
      await _loadUserNames();
    } else {
      setState(() {
        _isLoadingNames = false;
      });
    }
  }

  Future<void> _loadUserNames() async {
    final accountsProvider = Provider.of<AccountsProvider>(context, listen: false);
    final currentUser = accountsProvider.currentUser;
    
    if (currentUser == null) {
      setState(() {
        _isLoadingNames = false;
      });
      return;
    }

    setState(() {
      _isLoadingNames = true;
    });

    final names = await accountsProvider.getUserNames(currentUser.uid);
    
    if (mounted) {
      setState(() {
        _userNames = names;
        _isLoadingNames = false;
      });
    }
  }

  Future<void> _signOutAndNavigate(BuildContext context, LoginProvider loginProvider) async {
    final expenseProvider = Provider.of<ExpenseListProvider>(context, listen: false);
    await expenseProvider.clearExpensesOnSignOut();
    await loginProvider.logout();
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AccountLandingPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final expenseProvider = Provider.of<ExpenseListProvider>(context);
    final accountsProvider = Provider.of<AccountsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[800],
        title: _isLoadingNames
            ? const Text('Loading...', style: TextStyle(color: Colors.white))
            : Text(
                '${_userNames?['firstName'] ?? accountsProvider.currentAccount?.firstName ?? 'Unknown'} '
                '${_userNames?['lastName'] ?? accountsProvider.currentAccount?.lastName ?? 'User'}',
                style: const TextStyle(color: Colors.white),
              ),
        actions: [
          TextButton.icon(
            onPressed: () => _signOutAndNavigate(context, loginProvider),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: expenseProvider.expenses.isEmpty
          ? const Center(child: Text("No expenses found"))
          : ListView.builder(
              itemCount: expenseProvider.expenses.length,
              itemBuilder: (context, index) {
                final expense = expenseProvider.expenses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: expense.isPaid ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: expense.isPaid,
                          onChanged: (value) async {
                            final updated = Expense(
                              id: expense.id,
                              name: expense.name,
                              description: expense.description,
                              category: expense.category,
                              amount: expense.amount,
                              isPaid: value ?? false,
                            );
                            await expenseProvider.editExpense(expense.id!, updated);
                          },
                          checkColor: Colors.white,
                          activeColor: Colors.green[800],
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditExpense(expense: expense),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                expense.name,
                                style: TextStyle(
                                  color: expense.isPaid ? Colors.white : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => expenseProvider.deleteExpense(expense.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ExpensesForm()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}