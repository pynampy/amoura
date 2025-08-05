import 'package:amoura/common_widgets/back_button.dart';
import 'package:amoura/common_widgets/custom_button.dart';
import 'package:amoura/common_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignupPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignupRequested(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // disables default back button
        leading: BackButtonWidget(
          onTap: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthAuthenticated) {
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            } else if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      "Take your relationship to the next level",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),

                    RoundedTextField(
                      label: "Name",
                      hintText: "Enter your name",
                      controller: _nameController,
                    ),

                    SizedBox(height: 15),

                    RoundedTextField(
                      label: "Email",
                      hintText: "Enter your email",
                      controller: _emailController,
                    ),

                    SizedBox(height: 15),

                    RoundedTextField(
                      label: "Password",
                      hintText: "Enter your password",
                      controller: _passwordController,
                      obscureText: true,
                    ),

                    SizedBox(height: 30),

                    CustomButton(
                      text: isLoading ? "Creating..." : "Create Account",
                      onPressed: () {
                        isLoading ? null : _onSignupPressed(context);
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text("Already have an account? Log in"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
