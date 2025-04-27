// import 'package:flutter/material.dart';
// import '../api/login_api.dart';

// class LoginProvider with ChangeNotifier {
//   late LoginAPI loginService;
//   bool _isLoading = false;
//   String? _errorMessage;

//   LoginProvider() {
//     loginService = LoginAPI();
//   }

//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   Future<bool> login(String email, String password, {required bool keepSignedIn}) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       String result = await loginService.loginUser(email, password);
//       if (result.contains("Successfully")) {
//         _errorMessage = null;
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _errorMessage = result;
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _errorMessage = "An unexpected error occurred";
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   Future<void> logout() async {
//     await loginService.logoutUser();
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import '../api/login_api.dart';
import '../auth/login_auth.dart';

class LoginProvider with ChangeNotifier {
  late LoginAPI loginService;
  final LoginAuth _loginAuth = LoginAuth();

  bool _isLoading = false;
  String? _errorMessage;

  LoginProvider() {
    loginService = LoginAPI();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password, {bool keepSignedIn = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loginAuth.setPersistence(keepSignedIn: keepSignedIn);

      String result = await loginService.loginUser(email, password);
      if (result.contains("Successfully")) {
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "An unexpected error occurred";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await loginService.logoutUser();
    notifyListeners();
  }
}
