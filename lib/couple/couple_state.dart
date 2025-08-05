import 'package:equatable/equatable.dart';

abstract class CoupleState extends Equatable {
  const CoupleState();

  @override
  List<Object?> get props => [];
}

class CoupleInitial extends CoupleState {}

class CoupleLoading extends CoupleState {}

class CoupleCodeGenerated extends CoupleState {
  final String code;
  const CoupleCodeGenerated(this.code);

  @override
  List<Object?> get props => [code];
}

class CoupleError extends CoupleState {
  final String message;
  const CoupleError(this.message);

  @override
  List<Object?> get props => [message];
}

class CoupleLinked extends CoupleState {
  final String partnerName;

  const CoupleLinked(this.partnerName);

  @override
  List<Object?> get props => [partnerName];
}
