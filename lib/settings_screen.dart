import 'package:amoura/user/user_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  return Text("Logged in as: ${state.name}");
                } else if (state is UserError) {
                  return Text("Error: ${state.message}");
                }
                return CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 24),

            const Text(
              "Couple Status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // This section will later update based on BLoC state
            const Text("Not linked to a partner."),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Navigate to invite/link flow
                Navigator.pushNamed(context, '/link-partner');
              },
              child: const Text("Link with Partner"),
            ),

            const Spacer(),

            Center(
              child: ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
