import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('سياسة الخصوصية'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سياسة الخصوصية',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'نحن نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية. '
                    'توضح هذه السياسة كيفية جمع واستخدام وحماية المعلومات داخل تطبيق SotKonya.',
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _SectionCard(
              child: _PolicySection(
                title: '1. المعلومات التي نقوم بجمعها',
                content:
                    'قد نقوم بجمع بعض المعلومات الأساسية عند استخدامك للتطبيق، مثل:\n'
                    '- البريد الإلكتروني أو بيانات الحساب عند التسجيل.\n'
                    '- معلومات الاستخدام داخل التطبيق.\n'
                    '- إعدادات التطبيق التي تختارها.',
              ),
            ),

            _SectionCard(
              child: _PolicySection(
                title: '2. كيفية استخدام المعلومات',
                content:
                    'نستخدم المعلومات التي يتم جمعها من أجل تحسين تجربة المستخدم، '
                    'وتقديم المحتوى المناسب، والتواصل مع المستخدمين عند الحاجة.',
              ),
            ),

            _SectionCard(
              child: _PolicySection(
                title: '3. مشاركة المعلومات',
                content:
                    'لا نقوم ببيع أو مشاركة بياناتك الشخصية مع أي طرف ثالث، '
                    'إلا في الحالات التي يتطلبها القانون أو لتشغيل الخدمات الأساسية.',
              ),
            ),

            _SectionCard(
              child: _PolicySection(
                title: '4. حماية البيانات',
                content:
                    'نحرص على اتخاذ الإجراءات اللازمة لحماية بيانات المستخدمين '
                    'من الوصول غير المصرح به أو التعديل أو الفقدان.',
              ),
            ),

            _SectionCard(
              child: _PolicySection(
                title: '5. الإشعارات',
                content:
                    'يمكنك التحكم في إعدادات الإشعارات من داخل التطبيق في أي وقت.',
              ),
            ),

            _SectionCard(
              child: _PolicySection(
                title: '6. التعديلات على سياسة الخصوصية',
                content:
                    'قد نقوم بتحديث سياسة الخصوصية من وقت لآخر، '
                    'وسيتم عرض أي تحديث داخل التطبيق.',
              ),
            ),

            _SectionCard(
              child: _PolicySection(
                title: '7. التواصل معنا',
                content:
                    'في حال وجود أي استفسار بخصوص سياسة الخصوصية، '
                    'يمكنك التواصل معنا عبر إدارة التطبيق.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.35)),
      ),
      child: child,
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;

  const _PolicySection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }
}
