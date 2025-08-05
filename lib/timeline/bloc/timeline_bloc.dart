import 'package:amoura/timeline/bloc/timeline_events.dart';
import 'package:amoura/timeline/bloc/timeline_states.dart';
import 'package:amoura/timeline/repository/timeline_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimelineBloc extends Bloc<TimelineEvents, TimelineState> {
  final TimelineRepository repository = TimelineRepository();

  TimelineBloc() : super(TimelineInitial()) {
    on<FetchJournalEntries>((event, emit) async {
      emit(TimelineLoading());
      try {
        final entries = await repository.fetchJournalEntries(event.coupleId);
        emit(TimelineLoaded(entries));
      } catch (e) {
        print(e);
        emit(TimelineError(e.toString()));
      }
    });
  }
}
