// forgot_status.dart
import 'package:flutter/material.dart';
import 'sign_in.dart';

class ForgotStatusPage extends StatelessWidget {
  final bool isSuccess;

  const ForgotStatusPage({super.key, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          ),
        ),
        title: const Text('Password Reset'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                child: isSuccess
                    ? const Icon(Icons.email, size: 100, color: Colors.green)
                    : const Icon(Icons.close, size: 100, color: Colors.red),
              ),
              const SizedBox(height: 30),
              Text(
                isSuccess
                    ? 'Password reset link successfully sent to your email'
                    : 'Too many requests, please try again later',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}