import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/complete_profile_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';

import '../../features/chatbot/presentation/chatbot_screen.dart';
import '../../features/emergency/presentation/emergency_screen.dart';
import '../../features/home/presentation/favorites_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/menu/presentation/menu_screen.dart';
import '../../features/offers/presentation/offers_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/reservation/presentation/confirm_reservation_screen.dart';
import '../../features/reservation/presentation/create_reservation_screen.dart';
import '../../features/reservation/presentation/reservation_list_screen.dart';
import '../../features/wallet/presentation/wallet_screen.dart';

import '../widgets/image_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/auth/forgot', builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/auth/otp', builder: (_, __) => const OtpScreen()),
      GoRoute(path: '/auth/complete-profile', builder: (_, __) => const CompleteProfileScreen()),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/favorites', builder: (_, __) => const FavoritesScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/chatbot', builder: (_, __) => const ChatbotScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/offers', builder: (_, __) => const OffersScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
            ],
          ),
        ],
      ),

      GoRoute(path: '/wallet', builder: (_, __) => const WalletScreen()),
      GoRoute(path: '/menu', builder: (_, __) => const MenuScreen()),
      GoRoute(path: '/emergency', builder: (_, __) => const EmergencyScreen()),
      GoRoute(path: '/reservations', builder: (_, __) => const ReservationListScreen()),
      GoRoute(path: '/reservations/create', builder: (_, __) => const CreateReservationScreen()),
      GoRoute(
        path: '/reservations/confirm',
        builder: (_, state) {
          final payload = (state.extra as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
          return ConfirmReservationScreen(payload: payload);
        },
      ),

      GoRoute(
        path: '/notifications',
        builder: (_, __) => const ImageScreen(
          title: 'الإشعارات',
          assetPath: 'assets/screens/18_notification_screen.jpg',
        ),
      ),
      GoRoute(
        path: '/search',
        builder: (_, __) => const ImageScreen(
          title: 'بحث',
          assetPath: 'assets/screens/Search.jpg',
        ),
      ),
      GoRoute(
        path: '/location',
        builder: (_, __) => const ImageScreen(
          title: 'الموقع',
          assetPath: 'assets/screens/19_Location_screen.jpg',
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => const ImageScreen(
          title: 'الإعدادات',
          assetPath: 'assets/screens/52_Settings.jpg',
        ),
      ),
      GoRoute(
        path: '/help',
        builder: (_, __) => const ImageScreen(
          title: 'المساعدة والدعم',
          assetPath: 'assets/screens/58_Help and Support.jpg',
        ),
      ),
      GoRoute(
        path: '/complain',
        builder: (_, __) => const ImageScreen(
          title: 'الشكاوى',
          assetPath: 'assets/screens/48_Complain.jpg',
        ),
      ),
      GoRoute(
        path: '/about',
        builder: (_, __) => const ImageScreen(
          title: 'من نحن',
          assetPath: 'assets/screens/51_About Us.jpg',
        ),
      ),
    ],
  );
});

class _MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const _MainShell({required this.navigationShell});

  static const _tabs = [
    _TabItem(label: 'الرئيسية', icon: Icons.home_outlined),
    _TabItem(label: 'المفضلة', icon: Icons.favorite_border),
    _TabItem(label: 'سألنا', icon: Icons.smart_toy_outlined),
    _TabItem(label: 'العروض', icon: Icons.local_offer_outlined),
    _TabItem(label: 'حسابي', icon: Icons.person_outline),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF4B400),
        items: [
          for (final t in _tabs)
            BottomNavigationBarItem(
              icon: Icon(t.icon),
              label: t.label,
            ),
        ],
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  const _TabItem({required this.label, required this.icon});
}
