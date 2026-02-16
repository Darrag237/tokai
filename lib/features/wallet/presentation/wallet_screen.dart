import 'package:flutter/material.dart';

import '../../../core/widgets/tokai_scaffold.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TokaiScaffold(
      title: 'المحفظة',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/screens/38_Wallet.jpg', fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          const Text(
            'هذه شاشة محفظة مبسطة (للتوافق مع التصميم). يمكن توسيعها لاحقاً وربطها ببوابات الدفع.',
          ),
          const SizedBox(height: 16),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'إضافة مبلغ'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تمت الإضافة (Stub)')),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}
