import 'dart:ui';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'riwayat_screen.dart';
import 'statistik_screen.dart';
import 'kategori_screen.dart';
import 'pengaturan_screen.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/toast_stack.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final PageController _pageController;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const RiwayatScreen(),
    const StatistikScreen(),
    const KategoriScreen(),
    const PengaturanScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void switchToTab(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void _onNavItemTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            children: _screens,
          ),
          extendBody: true,
          bottomNavigationBar: _buildFloatingNavBar(),
        ),
        const ToastStack(),
      ],
    );
  }

  Widget _buildFloatingNavBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 72,
          padding: EdgeInsets.only(top: 8, bottom: MediaQuery.of(context).padding.bottom + 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF222238).withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.85),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(child: _buildNavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Beranda', index: 0)),
              Expanded(child: _buildNavItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long_rounded, label: 'Riwayat', index: 1)),
              Expanded(child: _buildNavItem(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart_rounded, label: 'Stats', index: 2)),
              Expanded(child: _buildNavItem(icon: Icons.category_outlined, activeIcon: Icons.category_rounded, label: 'Kategori', index: 3)),
              Expanded(child: _buildNavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded, label: 'Atur', index: 4)),
            ],
          ),
        ),
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
      onTap: () => _onNavItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.grey : const Color(0xFF8B95A7)),
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.grey : const Color(0xFF8B95A7)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
