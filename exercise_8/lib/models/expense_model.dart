import 'dart:convert';

class Expense {
  String? id;
  String name;
  String description;
  String category;
  int amount;

  Expense({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.amount,
  });

  factory Expense.fromJson(Map<String, dynamic> json, String id) {
    return Expense(
      id: id,
      name: json['name'],
      description: json['description'],
      category: json['category'],
      amount: json['amount'],
    );
  }

  static List<Expense> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Expense>((dynamic d) => Expense.fromJson(d, d['id'])).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'amount': amount,
    };
  }
}
