import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/tokai_scaffold.dart';
import '../../auth/providers/auth_controller.dart';
import '../../auth/providers/user_profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileSnap = ref.watch(userProfileDocProvider);

    String name = 'الاسم';
    String email = '';
    profileSnap.whenData((doc) {
      final data = doc.data();
      if (data != null && (data['name'] as String?)?.isNotEmpty == true) {
        name = data['name'] as String;
      }
    });

    return TokaiScaffold(
      title: 'حسابي',
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await ref.read(authControllerProvider.notifier).signOut();
            if (context.mounted) context.go('/welcome');
          },
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/screens/43_Profile.jpg', fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          Text(name, style: Theme.of(context).textTheme.titleLarge),
          if (email.isNotEmpty) Text(email),
          const SizedBox(height: 16),
          _Tile(icon: Icons.person, title: 'تعديل الملف الشخصي', onTap: () => context.push('/auth/complete-profile')),
          _Tile(icon: Icons.schedule, title: 'الحجوزات المسبقة', onTap: () => context.push('/reservations')),
          _Tile(icon: Icons.warning, title: 'زر الطوارئ', onTap: () => context.push('/emergency')),
          _Tile(icon: Icons.settings, title: 'الإعدادات', onTap: () => context.push('/settings')),
          _Tile(icon: Icons.help_outline, title: 'المساعدة والدعم', onTap: () => context.push('/help')),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _Tile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_left),
        onTap: onTap,
      ),
    );
  }
}
