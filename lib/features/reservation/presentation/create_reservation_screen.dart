import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/tokai_scaffold.dart';

class CreateReservationScreen extends StatefulWidget {
  const CreateReservationScreen({super.key});

  @override
  State<CreateReservationScreen> createState() => _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickup = TextEditingController();
  final _dropoff = TextEditingController();
  final _notes = TextEditingController();

  DateTime? _scheduledAt;
  String _repeatType = 'none';
  final Set<int> _customDays = {};

  @override
  void dispose() {
    _pickup.dispose();
    _dropoff.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: _scheduledAt ?? now.add(const Duration(days: 1)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt ?? now.add(const Duration(hours: 1))),
    );
    if (time == null) return;

    setState(() {
      _scheduledAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  String? _validateScheduledAt() {
    if (_scheduledAt == null) return 'اختر موعد الحجز';
    if (_scheduledAt!.isBefore(DateTime.now().add(const Duration(minutes: 1)))) {
      return 'يجب أن يكون الموعد في المستقبل';
    }
    if (_repeatType == 'custom' && _customDays.isEmpty) {
      return 'اختر أيام التكرار';
    }
    return null;
  }

  void _next() {
    final scheduledError = _validateScheduledAt();
    if (!_formKey.currentState!.validate() || scheduledError != null) {
      if (scheduledError != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(scheduledError)));
      }
      return;
    }

    context.push(
      '/reservations/confirm',
      extra: {
        'pickupText': _pickup.text.trim(),
        'dropoffText': _dropoff.text.trim(),
        'scheduledAt': _scheduledAt!,
        'repeatType': _repeatType,
        'repeatDays': _customDays.toList()..sort(),
        'notes': _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TokaiScaffold(
      title: 'إنشاء حجز مسبق',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFF2F2F2),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: const Center(
              child: Text('خريطة (Placeholder)\nTODO: دمج خرائط/أماكن'),
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _pickup,
                  decoration: const InputDecoration(labelText: 'مكان الالتقاط'),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dropoff,
                  decoration: const InputDecoration(labelText: 'مكان الوصول'),
                  validator: Validators.requiredField,
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _pickDateTime,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'التاريخ والوقت',
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _scheduledAt == null ? 'اختر الموعد' : _scheduledAt.toString(),
                          ),
                        ),
                        const Icon(Icons.calendar_month_outlined),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _repeatType,
                  decoration: const InputDecoration(labelText: 'نمط التكرار'),
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('بدون')),
                    DropdownMenuItem(value: 'daily', child: Text('يومي')),
                    DropdownMenuItem(value: 'weekly', child: Text('أسبوعي')),
                    DropdownMenuItem(value: 'custom', child: Text('مخصص (أيام محددة)')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _repeatType = v;
                      if (_repeatType != 'custom') _customDays.clear();
                    });
                  },
                ),
                if (_repeatType == 'custom') ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _DayChip(day: 1, label: 'الاثنين', selected: _customDays.contains(1), onTap: _toggleDay),
                        _DayChip(day: 2, label: 'الثلاثاء', selected: _customDays.contains(2), onTap: _toggleDay),
                        _DayChip(day: 3, label: 'الأربعاء', selected: _customDays.contains(3), onTap: _toggleDay),
                        _DayChip(day: 4, label: 'الخميس', selected: _customDays.contains(4), onTap: _toggleDay),
                        _DayChip(day: 5, label: 'الجمعة', selected: _customDays.contains(5), onTap: _toggleDay),
                        _DayChip(day: 6, label: 'السبت', selected: _customDays.contains(6), onTap: _toggleDay),
                        _DayChip(day: 7, label: 'الأحد', selected: _customDays.contains(7), onTap: _toggleDay),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notes,
                  decoration: const InputDecoration(labelText: 'ملاحظات (اختياري)'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: _next, child: const Text('التالي')),
          const SizedBox(height: 8),
          const Text(
            'TODO: Local notification stub عند إنشاء حجز متكرر.',
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  void _toggleDay(int d) {
    setState(() {
      if (_customDays.contains(d)) {
        _customDays.remove(d);
      } else {
        _customDays.add(d);
      }
    });
  }
}

class _DayChip extends StatelessWidget {
  final int day;
  final String label;
  final bool selected;
  final void Function(int) onTap;

  const _DayChip({required this.day, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(day),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF4B400) : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : Colors.black87, fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ),
    );
  }
}
