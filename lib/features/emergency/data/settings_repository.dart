import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/emergency_settings.dart';

class SettingsRepository {
  final FirebaseFirestore _db;
  SettingsRepository(this._db);

  Stream<EmergencySettings> watchEmergency(String userId) {
    return _db.collection('user_settings').doc(userId).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return EmergencySettings.defaults();
      final msg = (data['emergencyMessageTemplate'] as String?)?.trim();
      final targets = ((data['emergencyTargets'] as List?) ?? const []).map((e) => e.toString()).toList();
      return EmergencySettings(
        messageTemplate: (msg == null || msg.isEmpty) ? EmergencySettings.defaults().messageTemplate : msg,
        targets: targets.isEmpty ? EmergencySettings.defaults().targets : targets,
      );
    });
  }

  Future<void> saveEmergency(String userId, EmergencySettings settings) async {
    try {
      await _db.collection('user_settings').doc(userId).set({
        'emergencyMessageTemplate': settings.messageTemplate,
        'emergencyTargets': settings.targets,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw AppException('تعذر حفظ إعدادات الطوارئ', cause: e);
    }
  }
}
