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
  final String? coupleDocId;
  final String? partnerId;

  const UserLoaded({
    required this.name,
    required this.email,
    this.coupleDocId,
    this.partnerId,
  });

  bool get isUserLinked {
    return partnerId != null;
  }

  @override
  List<Object?> get props => [name, email];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
