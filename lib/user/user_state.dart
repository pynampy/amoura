part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final String name;
  final String email;
  final String? coupleId;

  const UserLoaded({
    required this.name,
    required this.email,
    required this.coupleId,
  });

  @override
  List<Object?> get props => [name, email, coupleId];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
