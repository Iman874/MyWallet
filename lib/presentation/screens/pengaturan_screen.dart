import 'package:flutter/material.dart';
import '../widgets/sticky_header.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          StickyHeader(
            title: 'Pengaturan',
            subtitle: 'Sesuaikan aplikasi',
            trailing: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: AppColors.textPrimary,
                size: 22,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Tampilan'),
                  const SizedBox(height: 12),
                  _buildThemeSection(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Tentang'),
                  const SizedBox(height: 12),
                  _buildAboutSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.heading4);
  }

  Widget _buildThemeSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildThemeOption(
            title: 'Mode Terang',
            subtitle: 'Gunakan tema terang',
            icon: Icons.light_mode_rounded,
            isSelected: _themeMode == ThemeMode.light,
            onTap: () => _setThemeMode(ThemeMode.light),
          ),
          const Divider(height: 1, indent: 56),
          _buildThemeOption(
            title: 'Mode Gelap',
            subtitle: 'Gunakan tema gelap',
            icon: Icons.dark_mode_rounded,
            isSelected: _themeMode == ThemeMode.dark,
            onTap: () => _setThemeMode(ThemeMode.dark),
          ),
          const Divider(height: 1, indent: 56),
          _buildThemeOption(
            title: 'Ikuti Sistem',
            subtitle: 'Sesuaikan dengan pengaturan perangkat',
            icon: Icons.brightness_auto_rounded,
            isSelected: _themeMode == ThemeMode.system,
            onTap: () => _setThemeMode(ThemeMode.system),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.greyLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.grey,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary, size: 22)
          : null,
      onTap: onTap,
    );
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    // TODO: Save to SharedPreferences and update theme
  }

  Widget _buildAboutSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAboutItem(
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'UangKu',
                applicationVersion: '1.0.0',
                applicationIcon: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F8CFF), Color(0xFF2F6BFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
                ),
                children: [
                  Text(
                    'Aplikasi pencatatan keuangan pribadi yang mudah digunakan.',
                    style: AppTextStyles.body,
                  ),
                ],
              );
            },
          ),
          const Divider(height: 1, indent: 56),
          _buildAboutItem(
            icon: Icons.code_rounded,
            title: 'Versi',
            trailing: Text('1.0.0', style: AppTextStyles.bodySmall),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.grey, size: 22),
      ),
      title: Text(title, style: AppTextStyles.body),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.grey),
      onTap: onTap,
    );
  }
}
