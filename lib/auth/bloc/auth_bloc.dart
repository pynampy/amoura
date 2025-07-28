import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.login(event.email, event.password);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthSignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signup(event.email, event.password);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    });

    on<AuthCheckStatus>((event, emit) async {
      final isLoggedIn = await authRepository.isLoggedIn();
      if (isLoggedIn) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }
}
