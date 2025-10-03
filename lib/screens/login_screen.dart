import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brl_task_2/services/firebase_auth_methods.dart';
import 'package:brl_task_2/widgets/custom_button.dart';
import 'package:brl_task_2/screens/signup_email_password_screen.dart';
import 'package:brl_task_2/screens/login_email_password_screen.dart';
import 'package:brl_task_2/screens/home_screen.dart';

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
            child: Image.asset('assets/login.png', fit: BoxFit.cover),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        20,
                      ), 
                    ),
                    child: const Text(
                      "Welcome",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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
                  const SizedBox(height: 15),

                  // BAAD ME HATANA HAI IS BUTTON KO
                  // VVIP
                  CustomButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    text: 'Go to Home (Test)',
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
