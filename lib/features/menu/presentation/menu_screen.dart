import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/screens/16_home_screen_Transport.jpg', fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.78,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  bottomLeft: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: const Text('الاسم'),
                      subtitle: const Text('name@email.com'),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    const Divider(height: 1),
                    _item(context, Icons.person_outline, 'تعديل الملف الشخصي', '/auth/complete-profile'),
                    _item(context, Icons.location_on_outlined, 'العنوان', '/location'),
                    _item(context, Icons.report_problem_outlined, 'الشكاوى', '/complain'),
                    _item(context, Icons.info_outline, 'اذا مين؟', '/about'),
                    _item(context, Icons.settings_outlined, 'الإعدادات', '/settings'),
                    _item(context, Icons.help_outline, 'المساعدة والدعم', '/help'),
                    _item(context, Icons.schedule, 'الحجوزات المسبقة', '/reservations'),
                    _item(context, Icons.warning_amber_rounded, 'زر الطوارئ', '/emergency'),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Tokai (TokTok) • Demo',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_left),
      onTap: () {
        context.pop();
        context.push(route);
      },
    );
  }
}
