import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/errors/app_exception.dart';

class UserProfileRepository {
  final FirebaseFirestore _db;
  UserProfileRepository(this._db);

  Future<void> upsertProfile({
    required String userId,
    required String name,
    String? phone,
  }) async {
    try {
      await _db.collection('user_profiles').doc(userId).set({
        'name': name,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw AppException('تعذر حفظ البيانات', cause: e);
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchProfile(String userId) {
    return _db.collection('user_profiles').doc(userId).snapshots();
  }
}
