import 'package:equatable/equatable.dart';

abstract class TimelineEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchJournalEntries extends TimelineEvents {
  final String coupleId;

  FetchJournalEntries(this.coupleId);

  @override
  List<Object?> get props => [coupleId];
}
