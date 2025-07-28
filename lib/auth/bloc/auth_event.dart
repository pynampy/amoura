abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email, password;
  AuthLoginRequested(this.email, this.password);
}

class AuthSignupRequested extends AuthEvent {
  final String email, password;
  AuthSignupRequested(this.email, this.password);
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}
