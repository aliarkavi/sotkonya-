import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'news_screen.dart';
import 'news_detail_screen.dart';
import 'housing_screen.dart';
import 'settings_screen.dart';
import 'events_screen.dart';

class MemberHomeScreen extends StatefulWidget {
  const MemberHomeScreen({super.key});

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _HomePage(), // الصفحة الرئيسية مع موجز الأخبار
    const EventsScreen(),
    const HousingScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'الفعاليات'),
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'السكن'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }
}

// -------------------------
// الصفحة الرئيسية مع الهيدر وموجز الأخبار والفعاليات القادمة
// -------------------------
class _HomePage extends StatelessWidget {
  const _HomePage();

  String _formatDate(Timestamp? ts) {
    if (ts == null) return '';
    final dt = ts.toDate().toLocal();
    return '${dt.day.toString().padLeft(2,'0')}/${dt.month.toString().padLeft(2,'0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final String userName = "أحمد محمد";

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // -------------------------
            // الهيدر
            // -------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0079A9),
                    Color(0xFF02BFA5),
                    Color(0xFFE5833A),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 28),
                  Column(
                    children: [
                      const Text(
                        "مرحباً،",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.white, size: 26),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // -------------------------
            // موجز آخر الأخبار
            // -------------------------
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('news')
                  .orderBy('createdAt', descending: true)
                  .limit(2)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Text('حدث خطأ أثناء جلب الأخبار');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) return const Text('لا توجد أخبار حالياً');

                return Card(
                  color: Colors.white,
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('آخر الأخبار',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const NewsScreen()),
                                );
                              },
                              child: const Text('عرض الكل',
                                  style: TextStyle(fontSize: 14, color: Colors.black)),
                            ),
                          ],
                        ),
                        const Divider(),
                        ...docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final title = data['title'] ?? '';
                          final desc = data['description'] ?? data['excerpt'] ?? '';
                          final imageUrl = data['imageUrl'] ?? '';
                          final ts = data['createdAt'] as Timestamp?;

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NewsDetailScreen(data: data),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: imageUrl.isNotEmpty
                                        ? Image.network(
                                            imageUrl,
                                            width: 80,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: 80,
                                            height: 60,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image),
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(desc,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13)),
                                        const SizedBox(height: 4),
                                        Text(_formatDate(ts),
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // -------------------------
            // موجز الفعاليات القادمة
            // -------------------------
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('events')
                  .orderBy('startDate')
                  .limit(2)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Text('حدث خطأ أثناء جلب الفعاليات');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) return const Text('لا توجد فعاليات حالياً');

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الفعاليات القادمة',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const EventsScreen()),
                            );
                          },
                          child: const Text('عرض الكل',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    ),
                    const Divider(),
                    ...docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final title = data['title'] ?? '';
                      final startTs = data['startDate'] as Timestamp?;
                      final location = data['location'] ?? '';

                      String dateStr = '';
                      if (startTs != null) {
                        final dt = startTs.toDate().toLocal();
                        dateStr =
                            '${dt.day.toString().padLeft(2,'0')}/${dt.month.toString().padLeft(2,'0')}/${dt.year}';
                      }

                      return InkWell(
                        onTap: () {
                          // يمكن إضافة تفاصيل الفعالية هنا
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const SizedBox(height: 4),
                                    Text(dateStr,
                                        style: const TextStyle(color: Colors.grey)),
                                    const SizedBox(height: 2),
                                    Text(location,
                                        style: const TextStyle(color: Colors.black54)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
