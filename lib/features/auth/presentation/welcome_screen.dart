import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/screens/05_Welcome _screen.jpg', fit: BoxFit.cover),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 44,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/auth/register'),
                    child: const Text('إنشاء حساب'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/auth/login'),
                    child: const Text('تسجيل الدخول'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
