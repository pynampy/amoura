abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email, password;
  AuthLoginRequested(this.email, this.password);
}

class AuthSignupRequested extends AuthEvent {
  final String email, password, name;
  AuthSignupRequested(this.email, this.password, this.name);
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}
