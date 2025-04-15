import 'package:flutter/material.dart';
import 'expenses_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ExpensesList(),
      debugShowCheckedModeBanner: false,
    );
  }
}
