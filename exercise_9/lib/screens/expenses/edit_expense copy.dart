

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/expense_model.dart';
import '../../providers/expense_provider.dart';

class EditExpense extends StatefulWidget {
  final Expense expense;
  const EditExpense({super.key, required this.expense});

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late String _selectedCategory;
  late bool _isPaid;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.expense.name);
    _descriptionController = TextEditingController(text: widget.expense.description);
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _selectedCategory = widget.expense.category;
    _isPaid = widget.expense.isPaid ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveEditedExpense() {
    if (_formKey.currentState!.validate()) {
      final updatedExpense = Expense(
        id: widget.expense.id,
        name: _nameController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        amount: int.parse(_amountController.text),
        isPaid: _isPaid,
      );

      Provider.of<ExpenseListProvider>(context, listen: false)
          .editExpense(widget.expense.id!, updatedExpense);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Select Category'),
                items: [
                  "Bills", "Transportation", "Food", "Utilities",
                  "Health", "Entertainment", "Miscellaneous"
                ].map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    )).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter amount' : null,
              ),
              CheckboxListTile(
                title: const Text('Paid'),
                value: _isPaid,
                onChanged: (value) {
                  setState(() {
                    _isPaid = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEditedExpense,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
