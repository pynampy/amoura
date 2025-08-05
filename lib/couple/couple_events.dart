import 'package:equatable/equatable.dart';

abstract class CoupleEvent extends Equatable {
  const CoupleEvent();

  @override
  List<Object?> get props => [];
}

class GenerateCodeRequested extends CoupleEvent {}

class FetchCoupleDetails extends CoupleEvent {}

class CoupleDetailsFetched extends CoupleEvent {
  final String partnerName;
  final String coupleId;
  const CoupleDetailsFetched({
    required this.partnerName,
    required this.coupleId,
  });
}

class CoupleLinkingRequested extends CoupleEvent {
  final String code;
  const CoupleLinkingRequested({required this.code});
}
