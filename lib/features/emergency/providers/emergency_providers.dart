
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/services/firebase_providers.dart';
import '../../auth/providers/auth_providers.dart';
import '../data/settings_repository.dart';
import '../domain/emergency_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(firestoreProvider));
});

final emergencySettingsProvider = StreamProvider<EmergencySettings>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(EmergencySettings.defaults());
  return ref.watch(settingsRepositoryProvider).watchEmergency(user.uid);
});

class EmergencyState {
  final EmergencySettings settings;
  final Set<String> selected;
  final bool isSaving;
  final String? error;

  EmergencyState({
    required this.settings,
    required this.selected,
    this.isSaving = false,
    this.error,
  });

  EmergencyState copyWith({EmergencySettings? settings, Set<String>? selected, bool? isSaving, String? error}) {
    return EmergencyState(
      settings: settings ?? this.settings,
      selected: selected ?? this.selected,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class EmergencyController extends StateNotifier<EmergencyState> {
  EmergencyController(this.ref)
      : super(
          EmergencyState(
            settings: EmergencySettings.defaults(),
            selected: EmergencySettings.defaults().targets.toSet(),
          ),
        ) {
    // keep in sync with Firestore
    _sub = ref.listen<AsyncValue<EmergencySettings>>(
      emergencySettingsProvider,
          (prev, next) {
        next.whenData((s) {
          state = state.copyWith(settings: s, selected: s.targets.toSet());
        });
      },
      fireImmediately: true,
    );
  }

  final Ref ref;
  late final ProviderSubscription _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }

  void toggleTarget(String number) {
    final next = {...state.selected};
    if (next.contains(number)) {
      next.remove(number);
    } else {
      next.add(number);
    }
    state = state.copyWith(selected: next);
  }

  void updateMessage(String message) {
    state = state.copyWith(settings: state.settings.copyWith(messageTemplate: message));
  }

  void setTargets(List<String> targets) {
    state = state.copyWith(
      settings: state.settings.copyWith(targets: targets),
      selected: targets.toSet(),
    );
  }

  Future<void> save() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = state.copyWith(error: 'غير مسجل دخول');
      return;
    }

    final msg = state.settings.messageTemplate.trim();
    if (msg.isEmpty) {
      state = state.copyWith(error: 'الرسالة مطلوبة');
      return;
    }
    if (state.selected.isEmpty) {
      state = state.copyWith(error: 'اختر جهة واحدة على الأقل');
      return;
    }

    state = state.copyWith(isSaving: true, error: null);
    try {
      final settingsToSave = state.settings.copyWith(targets: state.selected.toList());
      await ref.read(settingsRepositoryProvider).saveEmergency(user.uid, settingsToSave);
      state = state.copyWith(isSaving: false);
    } on AppException catch (e) {
      state = state.copyWith(isSaving: false, error: e.message);
    } catch (_) {
      state = state.copyWith(isSaving: false, error: 'حدث خطأ غير متوقع');
    }
  }

  Future<void> sendSms(String number) async {
    final msg = state.settings.messageTemplate.trim();
    final uri = Uri.parse('sms:$number?body=${Uri.encodeComponent(msg)}');

    try {
      final ok = await canLaunchUrl(uri);
      if (!ok) throw AppException('الجهاز لا يدعم إرسال SMS');
      await launchUrl(uri);
    } catch (e) {
      state = state.copyWith(error: 'تعذر فتح تطبيق الرسائل');
    }
  }
}

final emergencyControllerProvider = StateNotifierProvider<EmergencyController, EmergencyState>((ref) {
  return EmergencyController(ref);
});
