import 'package:flutter/material.dart';
import 'package:sotkonya/screens/news/news_screen.dart';

import 'screens/administration/administration_screen.dart';
import 'screens/event/event_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/yurtlar/yurtlar_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    NewsScreen(),
    EventScreen(),
    YurtlarScreen(),
    AdministrationScreen(),
    Center(child: Text("الإعدادات")),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => setState(() => currentIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  label: "الرئيسية",
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.article_outlined,
                  label: "الأخبار",
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.event_note_outlined,
                  label: "الفعاليات",
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.apartment_outlined,
                  label: "السكنات",
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.person_outline_sharp,
                  label: "الإدارة",
                ),
                _buildNavItem(
                  index: 5,
                  icon: Icons.settings_outlined,
                  label: "الإعدادات",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;

    final Color activeColor = Colors.blue;
    final Color inactiveColor = Colors.grey.shade500;

    return BottomNavigationBarItem(
      label: '',
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
