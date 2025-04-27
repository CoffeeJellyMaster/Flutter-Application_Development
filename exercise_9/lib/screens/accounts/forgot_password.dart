import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/accounts_provider.dart';
import 'forgot_status.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailTouched = false;
  String? _errorMessage;
  bool _isCheckingEmail = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isCheckingEmail = true;
          _errorMessage = null;
        });

        final provider = Provider.of<AccountsProvider>(context, listen: false);
        
        // First check if email exists in Firestore
        final emailExists = await provider.findEmailFromCollection(_emailController.text);
        if (!emailExists) {
          setState(() {
            _errorMessage = 'Email does not exist, please enter a valid email';
            _isCheckingEmail = false;
          });
          return;
        }

        // If email exists, try to send reset email
        await provider.sendPasswordResetEmail(_emailController.text);
        
        // If successful, navigate to status page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ForgotStatusPage(isSuccess: true),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'too-many-requests') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ForgotStatusPage(isSuccess: false),
            ),
          );
        } else {
          setState(() {
            _errorMessage = 'An error occurred. Please try again.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
      } finally {
        setState(() {
          _isCheckingEmail = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formFieldWidth = MediaQuery.of(context).size.width * 0.8;
    const formFieldHorizontalPadding = 24.0;
    final errorMessageLeftPadding = (MediaQuery.of(context).size.width - formFieldWidth) / 2;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(formFieldHorizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter your email address to receive a password reset link',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: formFieldWidth,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    onTap: () {
                      if (!_emailTouched) {
                        setState(() {
                          _emailController.text = '';
                          _emailTouched = true;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                if (_errorMessage != null)
                  Container(
                    width: formFieldWidth,
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 50,
                  child: _isCheckingEmail
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _sendPasswordResetEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}