import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/services/firebase_providers.dart';
import '../../auth/providers/auth_providers.dart';
import '../data/reservations_repository.dart';
import '../domain/reservation.dart';

final reservationsRepositoryProvider = Provider<ReservationsRepository>((ref) {
  return ReservationsRepository(ref.watch(firestoreProvider));
});

final upcomingReservationsProvider = StreamProvider.autoDispose<List<Reservation>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return ref.watch(reservationsRepositoryProvider).watchUpcoming(user.uid);
});

class CreateReservationState {
  final bool isLoading;
  final String? error;
  const CreateReservationState({this.isLoading = false, this.error});

  CreateReservationState copyWith({bool? isLoading, String? error}) {
    return CreateReservationState(isLoading: isLoading ?? this.isLoading, error: error);
  }
}

class CreateReservationController extends StateNotifier<CreateReservationState> {
  CreateReservationController(this.ref) : super(const CreateReservationState());

  final Ref ref;
  final _uuid = const Uuid();

  Future<bool> create({
    required String pickupText,
    required String dropoffText,
    required DateTime scheduledAt,
    required String repeatType,
    required List<int> repeatDays,
    String? notes,
  }) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = state.copyWith(error: 'غير مسجل دخول');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final reservation = Reservation(
        id: _uuid.v4(),
        userId: user.uid,
        pickupText: pickupText.trim(),
        dropoffText: dropoffText.trim(),
        scheduledAt: scheduledAt,
        repeatType: repeatType,
        repeatDays: repeatDays,
        notes: notes?.trim().isEmpty == true ? null : notes?.trim(),
        status: 'scheduled',
        createdAt: null,
        updatedAt: null,
      );

      await ref.read(reservationsRepositoryProvider).create(reservation);
      state = state.copyWith(isLoading: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'حدث خطأ غير متوقع');
      return false;
    }
  }
}

final createReservationControllerProvider = StateNotifierProvider<CreateReservationController, CreateReservationState>((ref) {
  return CreateReservationController(ref);
});
