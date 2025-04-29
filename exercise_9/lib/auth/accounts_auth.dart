import '../api/accounts_api.dart';

class AccountsAuth {
  final FirebaseAccountsAPI _api = FirebaseAccountsAPI();

  // Validate account creation
  Future<String> validateAndCreateAccount({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {

    if (!_isValidEmail(email)) {
      return "Please enter a valid email address";
    }

    if (!_isValidPassword(password)) {
      return "Password must be at least 6 characters and contain special characters";
    }


    try {
      bool exists = await _api.emailExists(email);
      if (exists) {
        return "Email already in use";
      }

      // Create account if validation passes
      return await _api.createAccountWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
    } catch (e) {
      return "Error creating account: $e";
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6 && 
           RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }
}

