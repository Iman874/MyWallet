import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'riwayat_screen.dart';
import 'statistik_screen.dart';
import 'kategori_screen.dart';
import 'pengaturan_screen.dart';
import '../../core/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const RiwayatScreen(),
    const StatistikScreen(),
    const KategoriScreen(),
    const PengaturanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      extendBody: true,
      bottomNavigationBar: _buildFloatingNavBar(),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      height: 72,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Beranda',
            index: 0,
          ),
          _buildNavItem(
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long_rounded,
            label: 'Riwayat',
            index: 1,
          ),
          _buildNavItem(
            icon: Icons.bar_chart_outlined,
            activeIcon: Icons.bar_chart_rounded,
            label: 'Statistik',
            index: 2,
          ),
          _buildNavItem(
            icon: Icons.category_outlined,
            activeIcon: Icons.category_rounded,
            label: 'Kategori',
            index: 3,
          ),
          _buildNavItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
            label: 'Pengaturan',
            index: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primary.withValues(alpha: 0.2) : const Color(0xFFEAF2FF))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.grey : const Color(0xFF8B95A7)),
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : const Color(0xFF8B95A7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
