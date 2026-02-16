import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/reservation.dart';

class ReservationsRepository {
  final FirebaseFirestore _db;
  ReservationsRepository(this._db);

  Stream<List<Reservation>> watchUpcoming(String userId) {
    return _db
        .collection('reservations')
        .where('userId', isEqualTo: userId)
        .orderBy('scheduledAt')
        .snapshots()
        .map((snap) => snap.docs.map(_fromDoc).toList());
  }

  Future<void> create(Reservation r) async {
    try {
      await _db.collection('reservations').doc(r.id).set({
        'userId': r.userId,
        'pickupText': r.pickupText,
        'dropoffText': r.dropoffText,
        'scheduledAt': Timestamp.fromDate(r.scheduledAt),
        'repeatType': r.repeatType,
        'repeatDays': r.repeatDays,
        'notes': r.notes,
        'status': r.status,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw AppException('تعذر حفظ الحجز', cause: e);
    }
  }

  Future<void> updateStatus({required String id, required String status}) async {
    try {
      await _db.collection('reservations').doc(id).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw AppException('تعذر تحديث الحجز', cause: e);
    }
  }

  Reservation _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> d) {
    final data = d.data();
    return Reservation(
      id: d.id,
      userId: (data['userId'] as String?) ?? '',
      pickupText: (data['pickupText'] as String?) ?? '',
      dropoffText: (data['dropoffText'] as String?) ?? '',
      scheduledAt: (data['scheduledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      repeatType: (data['repeatType'] as String?) ?? 'none',
      repeatDays: ((data['repeatDays'] as List?) ?? const []).map((e) => int.tryParse(e.toString()) ?? 0).where((e) => e > 0).toList(),
      notes: data['notes'] as String?,
      status: (data['status'] as String?) ?? 'scheduled',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
