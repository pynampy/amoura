import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().authRepository.getCurrentUser();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: Center(child: Text('Logged in as: ${user?.email ?? "Unknown"}')),
      ),
    );
  }
}
