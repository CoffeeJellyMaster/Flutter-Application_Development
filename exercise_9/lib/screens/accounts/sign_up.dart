
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../models/accounts_model.dart';
// import '../../providers/accounts_provider.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   String? _emailError;
//   bool _checkingEmail = false;

//   bool _hasSpecialCharacters(String password) {
//     return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter a password';
//     }

//     final hasMinLength = value.length >= 6;
//     final hasSpecialChars = _hasSpecialCharacters(value);

//     if (!hasMinLength && !hasSpecialChars) {
//       return 'Password must be at least 6 characters long and should contain special characters';
//     } else if (!hasMinLength) {
//       return 'Password must be at least 6 characters';
//     } else if (!hasSpecialChars) {
//       return 'Password must contain special characters';
//     }

//     return null;
//   }

//   String? _validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please confirm your password';
//     }
//     if (value != _passwordController.text) {
//       return 'Passwords do not match';
//     }
//     return null;
//   }

//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }
//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//       return 'Please enter a valid email';
//     }
//     return null;
//   }

//   Future<void> _checkEmailExists() async {
//     if (_emailController.text.isEmpty) return;

//     setState(() {
//       _checkingEmail = true;
//       _emailError = null;
//     });

//     final provider = Provider.of<AccountsProvider>(context, listen: false);
//     final emailExists = await provider.findEmailFromCollection(_emailController.text);

//     if (mounted) {
//       setState(() {
//         _checkingEmail = false;
//         _emailError = emailExists ? 'Email already in use' : null;
//       });
//     }
//   }

//   Future<void> _submitForm() async {
//     // First validate synchronously
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     // Then check email existence
//     await _checkEmailExists();
    
//     // If email exists, don't proceed
//     if (_emailError != null) {
//       return;
//     }

//     // Proceed with account creation
//     final newAccount = Account(
//       firstName: _firstNameController.text,
//       lastName: _lastNameController.text,
//       email: _emailController.text,
//       password: _passwordController.text,
//     );

//     final provider = Provider.of<AccountsProvider>(context, listen: false);
//     final result = await provider.signUp(newAccount);

//     if (!mounted) return;

//     if (result.contains("Successfully")) {
//       Navigator.pop(context);
//     } else {
//       setState(() {
//         _emailError = 'Email already in use'; // Fallback error
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLoading = context.watch<AccountsProvider>().isLoading;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign-Up'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _firstNameController,
//                 decoration: const InputDecoration(
//                   labelText: 'First name',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your first name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _lastNameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Last name',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your last name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   border: const OutlineInputBorder(),
//                   suffixIcon: _checkingEmail
//                       ? const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : null,
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: _validateEmail,
//                 onChanged: (value) {
//                   if (_emailError != null) {
//                     setState(() {
//                       _emailError = null;
//                     });
//                   }
//                 },
//                 onEditingComplete: () async {
//                   await _checkEmailExists();
//                 },
//               ),
//               if (_emailError != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4.0),
//                   child: Text(
//                     _emailError!,
//                     style: TextStyle(
//                       color: Colors.red[700],
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: _obscurePassword,
//                 validator: _validatePassword,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _confirmPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'Confirm Password',
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscureConfirmPassword = !_obscureConfirmPassword;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: _obscureConfirmPassword,
//                 validator: _validateConfirmPassword,
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: isLoading ? null : _submitForm,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text('CREATE ACCOUNT'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/accounts_model.dart';
import '../../providers/accounts_provider.dart';
import 'created_successful.dart'; // Add this import

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _emailError;
  bool _checkingEmail = false;

  bool _hasSpecialCharacters(String password) {
    return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    final hasMinLength = value.length >= 6;
    final hasSpecialChars = _hasSpecialCharacters(value);

    if (!hasMinLength && !hasSpecialChars) {
      return 'Password must be at least 6 characters long and should contain special characters';
    } else if (!hasMinLength) {
      return 'Password must be at least 6 characters';
    } else if (!hasSpecialChars) {
      return 'Password must contain special characters';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<void> _checkEmailExists() async {
    if (_emailController.text.isEmpty) return;

    setState(() {
      _checkingEmail = true;
      _emailError = null;
    });

    final provider = Provider.of<AccountsProvider>(context, listen: false);
    final emailExists = await provider.findEmailFromCollection(_emailController.text);

    if (mounted) {
      setState(() {
        _checkingEmail = false;
        _emailError = emailExists ? 'Email already in use' : null;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _checkEmailExists();
    
    if (_emailError != null) {
      return;
    }

    final newAccount = Account(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    final provider = Provider.of<AccountsProvider>(context, listen: false);
    final result = await provider.signUp(newAccount);

    if (!mounted) return;

    if (result.contains("Successfully")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CreatedSuccessfulPage()),
      );
    } else {
      setState(() {
        _emailError = 'Email already in use';
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AccountsProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign-Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  suffixIcon: _checkingEmail
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                onChanged: (value) {
                  if (_emailError != null) {
                    setState(() {
                      _emailError = null;
                    });
                  }
                },
                onEditingComplete: () async {
                  await _checkEmailExists();
                },
              ),
              if (_emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _emailError!,
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('CREATE ACCOUNT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}