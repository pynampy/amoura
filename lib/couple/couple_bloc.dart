// couple_bloc.dart
import 'package:amoura/couple/couple_events.dart';
import 'package:amoura/couple/couple_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'couple_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoupleBloc extends Bloc<CoupleEvent, CoupleState> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CoupleRepository _repository = CoupleRepository();

  CoupleBloc() : super(CoupleInitial()) {
    on<GenerateCodeRequested>(_onGenerateCode);
    on<CoupleLinkingRequested>(_onLinkRequested);
    on<FetchCoupleDetails>(_onFetchCoupleDetails);
  }

  Future<void> _onFetchCoupleDetails(
    FetchCoupleDetails event,
    Emitter<CoupleState> emit,
  ) async {
    emit(CoupleLoading());

    try {
      String partnerName = await _repository.fetchCoupleDetails();
      if (partnerName == "") {
        emit(CoupleInitial());
      }
      emit(CoupleLinked(partnerName));
    } catch (e) {
      emit(CoupleError(e.toString()));
    }
  }

  Future<void> _onLinkRequested(
    CoupleLinkingRequested event,
    Emitter<CoupleState> emit,
  ) async {
    emit(CoupleLoading());

    try {
      await _repository.linkWithPartnerCode(event.code);
      add(FetchCoupleDetails());
    } catch (e) {
      emit(CoupleError(e.toString()));
    }
  }

  Future<void> _onGenerateCode(
    GenerateCodeRequested event,
    Emitter<CoupleState> emit,
  ) async {
    emit(CoupleLoading());
    print("Reached");

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final userId = auth.currentUser!.uid;
      final code = _generateCode();

      // final coupleDoc = await firestore.collection('couples').add({
      //   'code': code,
      //   'users': [userId],
      //   'createdAt': FieldValue.serverTimestamp(),
      // });
      print(userId);

      await firestore.collection('users').doc(userId).update({
        'connectionCode': code,
      });

      emit(CoupleCodeGenerated(code));
    } catch (e) {
      print(e);
      emit(CoupleError("Failed to generate code"));
    }
  }

  String _generateCode() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now % 100000000).toString().padLeft(8, '0');
  }
}
