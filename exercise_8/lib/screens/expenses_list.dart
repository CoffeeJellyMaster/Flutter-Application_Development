
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'expenses_form.dart';
import 'edit_expense.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseListProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Expenses'),
            backgroundColor: Colors.green[800],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: provider.expenses,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final expenses = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Expense.fromJson(data, doc.id); // Fixed: 2 arguments
              }).toList();

              return ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return Card(
                    child: ListTile(
                      title: TextButton(
                        onPressed: () => _navigateToEditForm(context, expense),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            expense.name,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => provider.deleteExpense(expense.id!),
                      ),
                    ),
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
      },
    );
  }
}
