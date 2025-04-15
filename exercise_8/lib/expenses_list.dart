
// import 'package:flutter/material.dart';
// import 'expenses_form.dart';
// import 'edit_expense.dart';

// class Expense {
//   String name;
//   String description;
//   String category;
//   int amount;

//   Expense({
//     required this.name,
//     required this.description,
//     required this.category,
//     required this.amount,
//   });
// }

// class ExpensesList extends StatefulWidget {
//   const ExpensesList({super.key});

//   @override
//   State<ExpensesList> createState() => _ExpensesListState();
// }

// class _ExpensesListState extends State<ExpensesList> {
//   final List<Expense> _expenses = [];

//   void _addExpense(Expense expense) {
//     setState(() {
//       _expenses.add(expense);
//     });
//   }

//   void _updateExpense(int index, Expense updatedExpense) {
//     setState(() {
//       _expenses[index] = updatedExpense;
//     });
//   }

//   void _deleteExpense(int index) {
//     setState(() {
//       _expenses.removeAt(index);
//     });
//   }

//   void _navigateToAddForm() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const ExpensesForm()),
//     );

//     if (result != null && result is Expense) {
//       _addExpense(result);
//     }
//   }

//   void _navigateToEditForm(int index) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditExpense(expense: _expenses[index]),
//       ),
//     );

//     if (result != null && result is Expense) {
//       _updateExpense(index, result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Expenses')),
//       body: ListView.builder(
//         itemCount: _expenses.length,
//         itemBuilder: (context, index) {
//           final expense = _expenses[index];
//           return Card(
//             child: ListTile(
//               title: TextButton(
//                 onPressed: () => _navigateToEditForm(index),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     expense.name,
//                     style: const TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ),
//               trailing: IconButton(
//                 icon: const Icon(Icons.delete),
//                 onPressed: () => _deleteExpense(index),
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _navigateToAddForm,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'expenses_form.dart';
import 'edit_expense.dart';

class Expense {
  String name;
  String description;
  String category;
  int amount;

  Expense({
    required this.name,
    required this.description,
    required this.category,
    required this.amount,
  });
}

class ExpensesList extends StatefulWidget {
  const ExpensesList({super.key});

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  final List<Expense> _expenses = [];

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  void _updateExpense(int index, Expense updatedExpense) {
    setState(() {
      _expenses[index] = updatedExpense;
    });
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  void _navigateToAddForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExpensesForm()),
    );

    if (result != null && result is Expense) {
      _addExpense(result);
    }
  }

  void _navigateToEditForm(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpense(expense: _expenses[index]),
      ),
    );

    if (result != null && result is Expense) {
      _updateExpense(index, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: Colors.green[800], // Dark green
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          return Card(
            child: ListTile(
              title: TextButton(
                onPressed: () => _navigateToEditForm(index),
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
                onPressed: () => _deleteExpense(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
