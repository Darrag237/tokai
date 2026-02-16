import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/tokai_scaffold.dart';
import '../providers/emergency_providers.dart';

class EmergencyScreen extends ConsumerStatefulWidget {
  const EmergencyScreen({super.key});

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emergencyControllerProvider);

    if (_messageController.text.isEmpty || _messageController.text != state.settings.messageTemplate) {
      _messageController.text = state.settings.messageTemplate;
    }

    return TokaiScaffold(
      title: 'زر الطوارئ',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/screens/#U0637#U0648#U0627#U0631#U0626.jpg', fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          const Text(
            'اختر الجهات التي تريد إرسال SMS لها، وقم بتعديل نص الرسالة.',
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('الجهات'),
                  const SizedBox(height: 8),
                  _TargetTile(
                    title: 'رقم الشكاوي',
                    number: '16528',
                    selected: state.selected.contains('16528'),
                    onChanged: (_) => ref.read(emergencyControllerProvider.notifier).toggleTarget('16528'),
                    onSend: () => ref.read(emergencyControllerProvider.notifier).sendSms('16528'),
                  ),
                  _TargetTile(
                    title: 'شكاوي مجلس الوزراء',
                    number: '01555516528',
                    selected: state.selected.contains('01555516528'),
                    onChanged: (_) => ref.read(emergencyControllerProvider.notifier).toggleTarget('01555516528'),
                    onSend: () => ref.read(emergencyControllerProvider.notifier).sendSms('01555516528'),
                  ),
                  _TargetTile(
                    title: 'شكاوي مجلس الوزراء (2)',
                    number: '01555525444',
                    selected: state.selected.contains('01555525444'),
                    onChanged: (_) => ref.read(emergencyControllerProvider.notifier).toggleTarget('01555525444'),
                    onSend: () => ref.read(emergencyControllerProvider.notifier).sendSms('01555525444'),
                  ),
                  _TargetTile(
                    title: 'شكاوي النيابة العامة',
                    number: '01229869384',
                    selected: state.selected.contains('01229869384'),
                    onChanged: (_) => ref.read(emergencyControllerProvider.notifier).toggleTarget('01229869384'),
                    onSend: () => ref.read(emergencyControllerProvider.notifier).sendSms('01229869384'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => _showQuickSheet(context),
                    icon: const Icon(Icons.tune),
                    label: const Text('اختيار سريع (BottomSheet)'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('نص الرسالة'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _messageController,
                    maxLines: 4,
                    onChanged: (v) => ref.read(emergencyControllerProvider.notifier).updateMessage(v),
                    decoration: const InputDecoration(hintText: 'اكتب رسالة الطوارئ هنا'),
                  ),
                  const SizedBox(height: 8),
                  Text('Preview: ${state.settings.messageTemplate}', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: state.isSaving
                ? null
                : () async {
                    await ref.read(emergencyControllerProvider.notifier).save();
                    if (!context.mounted) return;
                    final err = ref.read(emergencyControllerProvider).error;
                    if (err != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ الإعدادات')));
                    }
                  },
            child: state.isSaving
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('حفظ'),
          ),
          const SizedBox(height: 8),
          if (state.error != null) Text(state.error!, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  void _showQuickSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('اختيار جهة للطوارئ', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _sheetBtn(context, 'رقم الشكاوي: 16528', '16528'),
                _sheetBtn(context, 'شكاوي مجلس الوزراء: 01555516528 / 01555525444', '01555516528'),
                _sheetBtn(context, 'شكاوي النيابة العامة: 01229869384', '01229869384'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sheetBtn(BuildContext context, String label, String number) {
    return OutlinedButton(
      onPressed: () {
        ref.read(emergencyControllerProvider.notifier).toggleTarget(number);
        Navigator.of(context).pop();
      },
      child: Text(label),
    );
  }
}

class _TargetTile extends StatelessWidget {
  final String title;
  final String number;
  final bool selected;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onSend;

  const _TargetTile({
    required this.title,
    required this.number,
    required this.selected,
    required this.onChanged,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: selected, onChanged: onChanged),
        Expanded(child: Text('$title ($number)')),
        IconButton(onPressed: onSend, icon: const Icon(Icons.sms_outlined)),
      ],
    );
  }
}
