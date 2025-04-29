
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../api/accounts_api.dart';
import '../auth/accounts_auth.dart';
import '../models/accounts_model.dart';

class AccountsProvider with ChangeNotifier {
  final FirebaseAccountsAPI _api = FirebaseAccountsAPI();
  final AccountsAuth _auth = AccountsAuth();
  User? _currentUser;
  Account? _currentAccount;
  bool _isLoading = false;

  AccountsProvider() {
    _initAuthListener();
  }

  User? get currentUser => _currentUser;
  Account? get currentAccount => _currentAccount;
  bool get isLoading => _isLoading;

  void _initAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _currentUser = user;
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _currentAccount = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userData = await _api.getUserData(uid);
      if (userData != null) {
        _currentAccount = Account.fromJson(userData, uid);
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, String>?> getUserNames(String uid) async {
    try {
      final data = await _api.getUserData(uid);
      if (data != null) {
        return {
          'firstName': data['firstName'] ?? '',
          'lastName': data['lastName'] ?? '',
        };
      }
      return null;
    } catch (e) {
      print("Error fetching user names: $e");
      return null;
    }
  }

  Future<String> signUp(Account account) async {
    try {
      _isLoading = true;
      notifyListeners();

      String result = await _auth.validateAndCreateAccount(
        email: account.email,
        password: account.password,
        firstName: account.firstName,
        lastName: account.lastName,
      );

      if (result.contains("Successfully") && _currentUser != null) {
        await _loadUserData(_currentUser!.uid);
      }

      return result;
    } catch (e) {
      return "Error during sign up: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      await FirebaseAuth.instance.signOut();
      _currentAccount = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      _isLoading = true;
      notifyListeners();
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // New function to check if email exists in Firestore
  Future<bool> findEmailFromCollection(String email) async {
    try {
      return await _api.emailExists(email);
    } catch (e) {
      print("Error finding email from collection: $e");
      return false;
    }
  }
}