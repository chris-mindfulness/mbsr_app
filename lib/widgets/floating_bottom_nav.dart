import 'package:flutter/material.dart';
import '../core/app_styles.dart';

class FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: AppStyles.glassBlur,
        child: Container(
          decoration: BoxDecoration(
            color: AppStyles.glassBackground,
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: AppStyles.glassBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              backgroundColor: Colors.transparent,
              selectedItemColor: AppStyles.primaryOrange,
              unselectedItemColor: AppStyles.textMuted,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.format_list_numbered),
                  label: 'Kurs',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music_outlined),
                  label: 'Mediathek',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.self_improvement),
                  label: 'Vertiefung',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
