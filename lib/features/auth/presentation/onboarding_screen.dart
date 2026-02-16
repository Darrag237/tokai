import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  final _pages = const [
    'assets/screens/01_Onboarding.jpg',
    'assets/screens/02_Onboarding.jpg',
    'assets/screens/03_Onboarding.jpg',
  ];

  void _next() {
    if (_index == _pages.length - 1) {
      context.go('/welcome');
      return;
    }
    _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) {
              return SizedBox.expand(
                child: Image.asset(_pages[i], fit: BoxFit.cover),
              );
            },
          ),
          Positioned(
            top: 46,
            right: 18,
            child: TextButton(
              onPressed: () => context.go('/welcome'),
              child: const Text('تخطي'),
            ),
          ),
          Positioned(
            bottom: 38,
            left: 0,
            right: 0,
            child: Center(
              child: InkWell(
                onTap: _next,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF4B400), width: 4),
                  ),
                  child: Center(
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF4B400),
                      ),
                      child: const Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
