import 'dart:convert';

class Account {
  String? id;
  String firstName;
  String lastName;
  String email;
  String password;

  Account({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  factory Account.fromJson(Map<String, dynamic> json, String id) {
    return Account(
      id: id,
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
    );
  }

  static List<Account> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<Account>((dynamic d) => Account.fromJson(d, d['id']))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }
}