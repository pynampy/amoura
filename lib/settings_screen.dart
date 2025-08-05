import 'package:amoura/common_widgets/back_button.dart';
import 'package:amoura/common_widgets/custom_button.dart';
import 'package:amoura/couple/couple_bloc.dart';
import 'package:amoura/couple/couple_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/welcome', (_) => false);
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
        title: Text("Settings", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ListTile(
            //   title: Text("Account Details"),
            //   trailing: Icon(Icons.arrow_forward_ios),
            // ),
            // Divider(),
            BlocBuilder<CoupleBloc, CoupleState>(
              builder: (context, state) {
                return ListTile(
                  onTap: () => state is CoupleLinked
                      ? null
                      : Navigator.pushNamed(context, '/link-partner'),
                  title: Text(
                    state is CoupleLinked
                        ? "Linked With ${state.partnerName}"
                        : "Connect with Partner",
                  ),
                  trailing: state is CoupleLinked
                      ? SizedBox()
                      : Icon(Icons.arrow_forward_ios),
                );
              },
            ),

            Divider(),

            // BlocBuilder<UserBloc, UserState>(
            //   builder: (context, state) {
            //     if (state is UserLoaded) {
            //       return Text("Logged in as: ${state.name}");
            //     } else if (state is UserError) {
            //       return Text("Error: ${state.message}");
            //     }
            //     return CircularProgressIndicator();
            //   },
            // ),
            // // BlocBuilder<CoupleBloc, CoupleState>(
            // //   builder: (context, state) {
            // //     if (state is UserLoaded) {
            // //       return Text("Logged in as:");
            // //     } else if (state is UserError) {
            // //       return Text("Error: ");
            // //     }
            // //     return CircularProgressIndicator();
            // //   },
            // // ),
            // const SizedBox(height: 24),

            // const Text(
            //   "Couple Status",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),

            // const SizedBox(height: 8),

            // BlocBuilder<UserBloc, UserState>(
            //   builder: (context, state) {
            //     if (state is UserLoaded) {
            //       if (state.isUserLinked) {
            //         return Text("Account Linked");
            //       } else {
            //         return Text("User not Linked");
            //       }
            //     }
            //     return Text("");
            //   },
            // ),

            // // const SizedBox(height: 8),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate to invite/link flow

            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //     builder: (_) => BlocProvider(
            //     //       create: (_) => CoupleBloc(
            //     //         firestore: FirebaseFirestore.instance,
            //     //         auth: FirebaseAuth.instance,
            //     //       ),
            //     //       child: LinkPartnerScreen(),
            //     //     ),
            //     //   ),
            //     // );
            //     Navigator.pushNamed(context, '/link-partner');
            //   },
            //   child: const Text("Link with Partner"),
            // ),
            const Spacer(),

            CustomButton(
              text: "Logout",
              onPressed: () => _logout(context),
              color: Colors.red,
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
