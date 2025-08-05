import 'package:amoura/common_widgets/custom_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Welcome to Amoura 💕',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // GestureDetector(
              //   onTap: () {
              //     Navigator.pushNamed(context, '/signup');
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(color: Colors.blue, borderRadius: 25),
              //     width: size.width,
              //     height: 50,

              //     child: Center(
              //       child: const Text(
              //         'Sign Up',
              //         style: TextStyle(color: Colors.white),
              //       ),
              //     ),
              //   ),
              // ),
              CustomButton(
                text: "Sign Up",
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
              ),
              const SizedBox(height: 12),
              Text("Or"),
              const SizedBox(height: 12),

              CustomButton(
                color: Colors.blue,
                text: "Login",
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
