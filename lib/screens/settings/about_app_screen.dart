import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('حول التطبيق'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  // Replace with your logo if you want
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                    child: Icon(
                      Icons.school_outlined,
                      size: 34,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'SotKonya',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'منصة طلابية تهدف إلى تسهيل وصول الطلاب إلى الأخبار والفعاليات والخدمات الجامعية، وتعزيز التواصل داخل المجتمع الطلابي في مكان واحد منظم وسهل الاستخدام.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Team section
            Text(
              'فريق العمل',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),

            _InfoCard(
              child: Column(
                children: const [
                  _PersonTile(
                    name: 'علي عرقاوي',
                    role: 'Backend Developer',
                    icon: Icons.storage_outlined,
                  ),
                  Divider(height: 0),
                  _PersonTile(
                    name: 'محمد حمدو',
                    role: 'Frontend Developer',
                    icon: Icons.code_outlined,
                  ),
                  Divider(height: 0),
                  _PersonTile(
                    name: 'حلا تاجي',
                    role: 'UI/UX Designer',
                    icon: Icons.palette_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Version / Legal
            _InfoCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.verified_outlined),
                    title: const Text('الإصدار'),
                    subtitle: const Text('1.0.0'),
                    dense: true,
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.copyright_outlined),
                    title: const Text('حقوق النشر'),
                    subtitle: Text('© ${DateTime.now().year} SotKonya'),
                    dense: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.35)),
      ),
      child: child,
    );
  }
}

class _PersonTile extends StatelessWidget {
  final String name;
  final String role;
  final IconData icon;

  const _PersonTile({
    required this.name,
    required this.role,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(role),
      dense: true,
    );
  }
}
