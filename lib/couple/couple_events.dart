import 'package:equatable/equatable.dart';

abstract class CoupleEvent extends Equatable {
  const CoupleEvent();

  @override
  List<Object> get props => [];
}

class GenerateCoupleCode extends CoupleEvent {}
