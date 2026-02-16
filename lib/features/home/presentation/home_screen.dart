import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/tokai_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTransport = true;

  @override
  Widget build(BuildContext context) {
    return TokaiScaffold(
      title: null,
      safeArea: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isTransport
                  ? 'assets/screens/16_home_screen_Transport.jpg'
                  : 'assets/screens/17_home_screen_delivery.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 52,
            right: 18,
            child: Row(
              children: [
                _SquareIconButton(
                  icon: Icons.notifications_none,
                  onTap: () => context.push('/notifications'),
                ),
                const SizedBox(width: 10),
                _SquareIconButton(
                  icon: Icons.search,
                  onTap: () => context.push('/search'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 52,
            left: 18,
            child: _SquareIconButton(
              icon: Icons.menu,
              onTap: () => context.push('/menu'),
            ),
          ),
          Positioned(
            bottom: 150,
            left: 18,
            child: SizedBox(
              width: 128,
              child: ElevatedButton(
                onPressed: () => context.push('/reservations'),
                child: const Text('حجز'),
              ),
            ),
          ),
          Positioned(
            bottom: 82,
            left: 18,
            right: 18,
            child: _HomeSearchCard(
              isTransport: isTransport,
              onToggle: (v) => setState(() => isTransport = v),
              onTapLocation: () => context.push('/location'),
              onWalletTap: () => context.push('/wallet'),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 240,
            child: FloatingActionButton(
              heroTag: 'emergencyFab',
              onPressed: () => context.push('/emergency'),
              backgroundColor: Colors.red,
              child: const Icon(Icons.warning_amber_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SquareIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF3C4),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }
}

class _HomeSearchCard extends StatelessWidget {
  final bool isTransport;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTapLocation;
  final VoidCallback onWalletTap;

  const _HomeSearchCard({
    required this.isTransport,
    required this.onToggle,
    required this.onTapLocation,
    required this.onWalletTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF4B400), width: 1),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTapLocation,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE9E9E9)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('إلى أين تريد الذهاب؟')),
                  IconButton(
                    icon: const Icon(Icons.account_balance_wallet_outlined),
                    onPressed: onWalletTap,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ToggleChip(
                  label: 'توصيل',
                  selected: !isTransport,
                  onTap: () => onToggle(false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ToggleChip(
                  label: 'تنقل',
                  selected: isTransport,
                  onTap: () => onToggle(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFF4B400) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
