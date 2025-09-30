import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brl_task_2/services/firebase_auth_methods.dart';
import 'package:brl_task_2/widgets/custom_textfield.dart';

class PasswordResetScreen extends StatefulWidget {
  static String routeName = '/password-reset';
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    setState(() => _isLoading = true);

    await context.read<FirebaseAuthMethods>().resetPassword(
      email: emailController.text.trim(),
      context: context,
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Reset Password',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : resetPassword,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}
