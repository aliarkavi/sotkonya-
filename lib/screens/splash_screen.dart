import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import 'admin_login_screen.dart';
import 'visitor_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151C26),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF232B39),
            borderRadius: BorderRadius.circular(28),
          ),
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'SOTKonya',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'اختر طريقة الدخول المناسبة لك',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB0B8C1),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _SplashButton(
                      color: const Color(0xFF0B3C49),
                      borderColor: const Color(0xFF1DE9B6),
                      icon: Icons.remove_red_eye_outlined,
                      title: 'تصفح كزائر',
                      subtitle: 'استكشف الأقسام العامة للمنصة',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const VisitorScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SplashButton(
                      color: const Color(0xFF0B2D49),
                      borderColor: const Color(0xFF1DE9B6),
                      icon: Icons.edit,
                      title: 'انتساب جديد',
                      subtitle: 'انضم إلينا كعضو جديد في التجمع',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SplashButton(
                      color: const Color(0xFF4B2B1B),
                      borderColor: const Color(0xFFFFA726),
                      icon: Icons.groups,
                      title: 'دخول الإدارة',
                      subtitle: 'خاص بالمسؤولين والمشرفين',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SplashButton(
                      color: const Color(0xFF1B1B4B),
                      borderColor: const Color(0xFF7C4DFF),
                      icon: Icons.login,
                      title: 'دخول الأعضاء',
                      subtitle: 'للأعضاء المسجلين مسبقاً',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashButton extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SplashButton({
    required this.color,
    required this.borderColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: borderColor, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFB0B8C1),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}




