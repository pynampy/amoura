import 'dart:math';
import 'package:amoura/couple/models/couple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoupleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _randomCode() {
    final rand = Random().nextInt(99999999).toString().padLeft(8, '0');
    return rand;
  }

  Future<String> generateCoupleCode() async {
    final uid = _auth.currentUser!.uid;
    final code = _randomCode();
    await _firestore.collection('users').doc(uid).update({'coupleCode': code});
    return code;
  }

  Future<bool> isCoupleLinked() async {
    final uid = _auth.currentUser!.uid;

    final doc = await _firestore.collection('users').doc(uid).get();

    if (doc.exists && doc.data()!.containsKey('partnerId')) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> linkWithPartnerCode(String code) async {
    final currentUid = _auth.currentUser!.uid;

    final currentUserDoc = await _firestore
        .collection('users')
        .doc(currentUid)
        .get();

    final currentUserName = currentUserDoc.data()?['name'];

    final partner = await _firestore
        .collection('users')
        .where('connectionCode', isEqualTo: code)
        .get();

    final partnerDoc = partner.docs.first;

    if (!partnerDoc.exists) {
      throw Exception("Invalid code");
    }

    final partnerCoupleId = partnerDoc.data()['coupleId'];
    final partnerName = partnerDoc.data()['name'];
    final partnerUid = partnerDoc.id;

    // Update both users
    final batch = _firestore.batch();
    final currentUserRef = _firestore.collection('users').doc(currentUid);
    final partnerUserRef = _firestore.collection('users').doc(partnerUid);
    final coupleRef = _firestore.collection('couples').doc(partnerCoupleId);

    batch.update(currentUserRef, {
      'partnerUid': partnerUid,
      'coupleId': partnerCoupleId,
      'linked': true,
    });
    batch.update(partnerUserRef, {
      'partnerUid': currentUid,
      'coupleId': partnerCoupleId,
      'linked': true,
    });
    batch.update(coupleRef, {
      'updatedAt': FieldValue.serverTimestamp(),
      'users': {currentUid: currentUserName, partnerUid: partnerName},
    });

    await batch.commit();
  }

  Future<String> fetchCoupleDetails() async {
    final uid = _auth.currentUser!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();
    final partnerUid = doc.data()?['partnerUid'];
    final coupleId = doc.data()?['coupleId'];
    final coupleDoc = await _firestore
        .collection('couples')
        .doc(coupleId)
        .get();
    final coupleData = coupleDoc.data();
    final partnerName = coupleData?['users']?[partnerUid];
    return partnerName;
  }
}
