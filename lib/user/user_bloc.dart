import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserLoading()) {
    on<LoadUser>(_onLoadUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(UserError("Not logged in"));
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final data = doc.data();

      if (data == null) {
        emit(UserError("User not found"));
        return;
      }

      print(data);

      emit(
        UserLoaded(
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          coupleDocId: data['coupleId'],
          partnerId: data['partnerUid'],
        ),
      );
    } catch (e) {
      emit(UserError("Failed to load user"));
    }
  }
}
