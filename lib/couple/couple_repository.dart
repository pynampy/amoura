import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoupleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> generateCoupleCode() async {
    final uid = _auth.currentUser!.uid;
    final code = _randomCode();

    await _firestore.collection('users').doc(uid).update({'coupleCode': code});

    return code;
  }

  Future<void> linkWithPartnerCode(String code) async {
    final currentUid = _auth.currentUser!.uid;

    // Find the user who owns the code
    final query = await _firestore
        .collection('users')
        .where('coupleCode', isEqualTo: code)
        .get();

    if (query.docs.isEmpty) {
      throw Exception("Invalid code");
    }

    final partnerDoc = query.docs.first;
    final partnerUid = partnerDoc.id;

    if (partnerUid == currentUid) {
      throw Exception("You can't link with yourself.");
    }

    // Update both users
    final batch = _firestore.batch();
    final currentUserRef = _firestore.collection('users').doc(currentUid);
    final partnerUserRef = _firestore.collection('users').doc(partnerUid);

    batch.update(currentUserRef, {'partnerUid': partnerUid});

    batch.update(partnerUserRef, {'partnerUid': currentUid});

    await batch.commit();
  }

  Future<String?> getPartnerName() async {
    final userDoc = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();

    final partnerUid = userDoc.data()?['partnerUid'];
    if (partnerUid == null) return null;

    final partnerDoc = await _firestore
        .collection('users')
        .doc(partnerUid)
        .get();

    return partnerDoc.data()?['name'];
  }

  String _randomCode() {
    final rand = Random().nextInt(99999999).toString().padLeft(8, '0');
    return rand;
  }
}
