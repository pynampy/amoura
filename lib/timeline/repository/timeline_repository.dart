import 'package:amoura/timeline/models/journal_entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimelineRepository {
  final FirebaseFirestore _firestore;

  TimelineRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<JournalEntry>> fetchJournalEntries(String coupleId) async {
    final snapshot = await _firestore
        .collection('journals')
        .where('coupleId', isEqualTo: coupleId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => JournalEntry.fromFirestore(doc)).toList();
  }
}
