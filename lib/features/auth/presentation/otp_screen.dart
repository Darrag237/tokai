import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/tokai_scaffold.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otp = TextEditingController();

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // This app uses Email/Password auth. OTP screen is for matching the UI flow.
    context.go('/auth/complete-profile');
  }

  @override
  Widget build(BuildContext context) {
    return TokaiScaffold(
      title: 'تأكيد OTP',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: Image.asset('assets/screens/07_verify_otp.jpg', fit: BoxFit.contain),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _otp,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'رمز التحقق (6 أرقام)'),
                validator: Validators.otp,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _submit, child: const Text('تأكيد')),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
