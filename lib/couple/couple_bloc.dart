import 'package:amoura/couple/couple_events.dart';
import 'package:amoura/couple/couple_repository.dart';
import 'package:amoura/couple/couple_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoupleBloc extends Bloc<CoupleEvent, CoupleState> {
  final CoupleRepository repository;
  final String userId;

  CoupleBloc({required this.repository, required this.userId})
    : super(CoupleInitial()) {
    on<GenerateCoupleCode>(_onGenerateCoupleCode);
  }

  Future<void> _onGenerateCoupleCode(
    GenerateCoupleCode event,
    Emitter<CoupleState> emit,
  ) async {
    emit(CoupleLoading());

    try {
      await repository.generateCoupleCode(userId);
      emit(CoupleCodeGenerated());
    } catch (e) {
      emit(CoupleError("Failed to generate couple code"));
    }
  }
}
