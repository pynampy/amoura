import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final List<String> photos;
  final DateTime createdAt;
  final String coupleId;
  final String? createdBy;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.photos,
    required this.createdAt,
    required this.coupleId,
    this.createdBy,
  });

  factory JournalEntry.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return JournalEntry(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      photos: List<String>.from(data['photos'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      coupleId: data['coupleId'] ?? '',
      createdBy: data['createdBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'photos': photos,
      'createdAt': Timestamp.fromDate(createdAt),
      'coupleId': coupleId,
      if (createdBy != null) 'createdBy': createdBy,
    };
  }
}
