import 'package:amoura/timeline/models/journal_entry.dart';
import 'package:equatable/equatable.dart';

abstract class TimelineState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TimelineInitial extends TimelineState {}

class TimelineLoading extends TimelineState {}

class TimelineLoaded extends TimelineState {
  final List<JournalEntry> entries;

  TimelineLoaded(this.entries);

  @override
  List<Object?> get props => [entries];
}

class TimelineError extends TimelineState {
  final String message;

  TimelineError(this.message);

  @override
  List<Object?> get props => [message];
}
