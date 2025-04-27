import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    _loadUserNames();
  }

  Future<void> _loadUserNames() async {
    final accountsProvider = Provider.of<AccountsProvider>(context, listen: false);
    final names = await accountsProvider.getUserNames(accountsProvider.currentUser?.uid ?? '');
    setState(() {
      _userNames = names;
      _isLoadingNames = false;
    });
  }

  void _navigateToAddForm(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExpensesForm()),
    );
  }

  void _navigateToEditForm(BuildContext context, Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditExpense(expense: expense),
      ),
    );
  }

  void _signOutAndNavigate(BuildContext context, LoginProvider loginProvider) {
    loginProvider.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AccountLandingPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final expenseProvider = Provider.of<ExpenseListProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[800],
        title: _isLoadingNames
            ? const Text('Loading...', style: TextStyle(color: Colors.white))
            : Text(
                '${_userNames?['firstName'] ?? 'Unknown'} ${_userNames?['lastName'] ?? 'User'}',
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
      body: Consumer<ExpenseListProvider>(
        builder: (context, provider, _) {
          return StreamBuilder<QuerySnapshot>(
            stream: provider.expenses,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No expenses found"));
              }

              final expenses = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Expense.fromJson(data, doc.id);
              }).toList();

              return ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: expense.isPaid == true ? Colors.green : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        children: [
                          StatefulBuilder(
                            builder: (context, setState) {
                              return Checkbox(
                                value: expense.isPaid ?? false,
                                onChanged: (value) async {
                                  final updatedExpense = Expense(
                                    id: expense.id,
                                    name: expense.name,
                                    description: expense.description,
                                    category: expense.category,
                                    amount: expense.amount,
                                    isPaid: value ?? false,
                                  );
                                  await expenseProvider.editExpense(expense.id!, updatedExpense);
                                  setState(() {});
                                },
                                checkColor: Colors.white,
                                activeColor: Colors.green[800],
                                fillColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.selected)) {
                                      return Colors.green[800]!;
                                    }
                                    return Colors.white;
                                  },
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => _navigateToEditForm(context, expense),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  expense.name,
                                  style: TextStyle(
                                    color: expense.isPaid == true ? Colors.white : Colors.black,
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
                            onPressed: () {
                              expenseProvider.deleteExpense(expense.id!);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}