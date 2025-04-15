import 'package:flutter/material.dart';
import 'expenses_list.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.expense.name);
    _descriptionController = TextEditingController(text: widget.expense.description);
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _selectedCategory = widget.expense.category;
  }

  void _saveEditedExpense() {
    if (_formKey.currentState!.validate()) {
      final updatedExpense = Expense(
        name: _nameController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        amount: int.parse(_amountController.text),
      );
      Navigator.pop(context, updatedExpense);
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
