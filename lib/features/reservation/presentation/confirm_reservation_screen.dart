import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/tokai_scaffold.dart';
import '../providers/reservation_providers.dart';

class ConfirmReservationScreen extends ConsumerWidget {
  final Map<String, dynamic> payload;
  const ConfirmReservationScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createReservationControllerProvider);
    final pickup = payload['pickupText'] as String;
    final dropoff = payload['dropoffText'] as String;
    final scheduledAt = payload['scheduledAt'] as DateTime;
    final repeatType = payload['repeatType'] as String;
    final repeatDays = (payload['repeatDays'] as List).cast<int>();
    final notes = payload['notes'] as String?;

    return TokaiScaffold(
      title: 'تأكيد الحجز',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الالتقاط: $pickup'),
                    const SizedBox(height: 8),
                    Text('الوصول: $dropoff'),
                    const SizedBox(height: 8),
                    Text('الموعد: $scheduledAt'),
                    const SizedBox(height: 8),
                    Text('التكرار: ${_repeatLabel(repeatType, repeatDays)}'),
                    if (notes != null) ...[
                      const SizedBox(height: 8),
                      Text('ملاحظات: $notes'),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      final ok = await ref.read(createReservationControllerProvider.notifier).create(
                            pickupText: pickup,
                            dropoffText: dropoff,
                            scheduledAt: scheduledAt,
                            repeatType: repeatType,
                            repeatDays: repeatDays,
                            notes: notes,
                          );
                      if (!context.mounted) return;
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ الحجز')));
                        context.go('/reservations');
                      } else {
                        final msg = ref.read(createReservationControllerProvider).error;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg ?? 'تعذر الحفظ')));
                      }
                    },
              child: state.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('حفظ'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: () => context.pop(), child: const Text('تعديل')),
            const Spacer(),
            const Text(
              'ملاحظة: إشعارات التذكير لم يتم تفعيلها (Stub) — راجع TODO في Create Reservation.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _repeatLabel(String type, List<int> days) {
    switch (type) {
      case 'daily':
        return 'يومي';
      case 'weekly':
        return 'أسبوعي';
      case 'custom':
        return 'مخصص (${days.join(',')})';
      default:
        return 'بدون';
    }
  }
}
