import 'package:amoura/add_journal.dart';
import 'package:amoura/auth/bloc/auth_bloc.dart';
import 'package:amoura/auth/bloc/auth_event.dart';
import 'package:amoura/auth/bloc/auth_state.dart';
import 'package:amoura/auth/repository/auth_repository.dart';
import 'package:amoura/auth/views/login_screen.dart';
import 'package:amoura/auth/views/signup_screen.dart';
import 'package:amoura/couple/couple_bloc.dart';
import 'package:amoura/couple/couple_events.dart';
import 'package:amoura/firebase_options.dart';
import 'package:amoura/home_screen.dart';
import 'package:amoura/link_partner_screen.dart';
import 'package:amoura/settings_screen.dart';
import 'package:amoura/timeline/bloc/timeline_bloc.dart';
import 'package:amoura/timeline/timeline_screen.dart';
import 'package:amoura/user/user_bloc.dart';
import 'package:amoura/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
              AuthBloc(authRepository: authRepository)..add(AuthCheckStatus()),
        ),
        BlocProvider<UserBloc>(create: (_) => UserBloc()..add(LoadUser())),
        BlocProvider<CoupleBloc>(
          create: (_) => CoupleBloc()..add(FetchCoupleDetails()),
        ),
        BlocProvider<TimelineBloc>(create: (_) => TimelineBloc()),
      ],
      child: MaterialApp(
        title: 'Amoura',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 0),
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        routes: {
          '/welcome': (_) => const WelcomeScreen(),
          '/signup': (_) => const SignUpScreen(),
          '/login': (_) => const LoginScreen(),
          '/home': (_) => const HomeScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/link-partner': (_) => const LinkPartnerScreen(),
          '/add-journal': (_) => AddJournalScreen(),
          '/timeline': (_) => TimelineScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticated) {
          return const HomeScreen();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
