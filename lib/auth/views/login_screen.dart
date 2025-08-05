import 'package:amoura/auth/bloc/auth_bloc.dart';
import 'package:amoura/auth/bloc/auth_event.dart';
import 'package:amoura/auth/bloc/auth_state.dart';
import 'package:amoura/common_widgets/back_button.dart';
import 'package:amoura/common_widgets/custom_button.dart';
import 'package:amoura/common_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      context.read<AuthBloc>().add(AuthLoginRequested(email, password));
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
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
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
                    "Log In",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  Text(
                    "Welcome back! Let's get you logged in!",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),

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
                    text: isLoading ? "Fetching your account..." : "Login",
                    onPressed: () {
                      isLoading ? null : _onLoginPressed((context));
                    },
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: const Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
