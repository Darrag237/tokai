import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/tokai_scaffold.dart';
import '../providers/reservation_providers.dart';

class ReservationListScreen extends ConsumerWidget {
  const ReservationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(upcomingReservationsProvider);

    return TokaiScaffold(
      title: 'الحجوزات المسبقة',
      actions: [
        IconButton(
          onPressed: () => context.push('/reservations/create'),
          icon: const Icon(Icons.add),
        )
      ],
      body: upcoming.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('لا توجد حجوزات قادمة'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.push('/reservations/create'),
                    child: const Text('إنشاء حجز'),
                  )
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final r = list[i];
              return Card(
                child: ListTile(
                  title: Text('${r.pickupText} → ${r.dropoffText}'),
                  subtitle: Text('الموعد: ${r.scheduledAt} • التكرار: ${_repeatLabel(r.repeatType, r.repeatDays)}'),
                  trailing: _StatusChip(status: r.status),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('حدث خطأ: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/reservations/create'),
        child: const Icon(Icons.add),
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

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    switch (status) {
      case 'cancelled':
        label = 'ملغي';
        color = Colors.red;
        break;
      case 'done':
        label = 'تم';
        color = Colors.green;
        break;
      default:
        label = 'مجدول';
        color = const Color(0xFFF4B400);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
    );
  }
}
