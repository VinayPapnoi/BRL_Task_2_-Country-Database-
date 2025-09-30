import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brl_task_2/services/firebase_auth_methods.dart';
import 'package:brl_task_2/widgets/custom_button.dart';
import 'package:brl_task_2/screens/signup_email_password_screen.dart';
import 'package:brl_task_2/screens/login_email_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/login.png', 
              fit: BoxFit.cover,
            ),
          ),
         
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Welcome",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                  ),
                  const SizedBox(height: 30),

                  CustomButton(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        EmailPasswordSignup.routeName,
                      );
                    },
                    text: 'Email/Password Sign Up',
                  ),
                  const SizedBox(height: 15),

                  CustomButton(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        EmailPasswordLogin.routeName,
                      );
                    },
                    text: 'Email/Password Log In',
                  ),
                  const SizedBox(height: 15),

                  CustomButton(
                    onTap: () {
                      context.read<FirebaseAuthMethods>().signInWithGoogle(
                        context,
                      );
                    },
                    text: 'Google Sign In',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
