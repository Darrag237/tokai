import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/faq_entry.dart';

class FaqRepository {
  final FirebaseFirestore _db;
  FaqRepository(this._db);

  Future<List<FaqEntry>> fetchAll({int limit = 200}) async {
    try {
      final snap = await _db.collection('faq').orderBy('updatedAt', descending: true).limit(limit).get();
      return snap.docs.map((d) {
        final data = d.data();
        return FaqEntry(
          id: d.id,
          question: (data['question'] as String?) ?? '',
          answer: (data['answer'] as String?) ?? '',
          tags: ((data['tags'] as List?) ?? const [])
              .map((e) => e.toString().toLowerCase().trim())
              .where((e) => e.isNotEmpty)
              .toList(),
        );
      }).toList();
    } catch (e) {
      throw AppException('تعذر تحميل قاعدة المعرفة', cause: e);
    }
  }

  /// Simple client-side matching: contains + tag match.
  Future<FaqEntry?> searchBest(String query) async {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return null;
    final all = await fetchAll();

    int score(FaqEntry e) {
      final text = (e.question + ' ' + e.answer).toLowerCase();
      int s = 0;
      if (text.contains(q)) s += 10;
      for (final t in e.tags) {
        if (q.contains(t) || t.contains(q)) s += 3;
      }
      // Partial token match.
      for (final token in q.split(RegExp(r'\s+')).where((t) => t.length >= 3)) {
        if (text.contains(token)) s += 1;
      }
      return s;
    }

    all.sort((a, b) => score(b).compareTo(score(a)));
    final top = all.isNotEmpty ? all.first : null;
    if (top == null) return null;
    return score(top) >= 4 ? top : null;
  }
}
