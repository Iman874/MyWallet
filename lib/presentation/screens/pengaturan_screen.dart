import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/batas_provider.dart';
import '../widgets/sticky_header.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/format.dart';

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          StickyHeader(
            title: 'Pengaturan',
            subtitle: 'Sesuaikan aplikasi',
            trailing: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.settings_outlined,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                size: 22,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Tampilan'),
                  const SizedBox(height: 12),
                  _buildThemeSection(context, themeProvider),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Batas Pemakaian'),
                  const SizedBox(height: 12),
                  _buildBatasSection(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Tentang'),
                  const SizedBox(height: 12),
                  _buildAboutSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.heading4Context(context),
    );
  }

  Widget _buildThemeSection(BuildContext context, ThemeProvider themeProvider) {
    final currentMode = themeProvider.themeMode;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildThemeOption(
            context: context,
            title: 'Mode Terang',
            subtitle: 'Gunakan tema terang',
            icon: Icons.light_mode_rounded,
            isSelected: currentMode == ThemeMode.light,
            onTap: () => themeProvider.setThemeMode(ThemeMode.light),
          ),
          const Divider(height: 1, indent: 56),
          _buildThemeOption(
            context: context,
            title: 'Mode Gelap',
            subtitle: 'Gunakan tema gelap',
            icon: Icons.dark_mode_rounded,
            isSelected: currentMode == ThemeMode.dark,
            onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
          ),
          const Divider(height: 1, indent: 56),
          _buildThemeOption(
            context: context,
            title: 'Ikuti Sistem',
            subtitle: 'Sesuaikan dengan pengaturan perangkat',
            icon: Icons.brightness_auto_rounded,
            isSelected: currentMode == ThemeMode.system,
            onTap: () => themeProvider.setThemeMode(ThemeMode.system),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
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
              : AppColors.forBrightness(context, AppColors.greyLight, AppColors.greyLightDark),
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
        style: AppTextStyles.bodyContext(context).copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected
              ? AppColors.primary
              : Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.captionContext(context)),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary, size: 22)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildBatasSection(BuildContext context) {
    return Consumer<BatasProvider>(
      builder: (context, batasProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildBatasItem(
                context: context,
                icon: Icons.today,
                title: 'Harian',
                value: batasProvider.batasHarian,
                color: AppColors.error,
                onChanged: (value) => batasProvider.setBatasHarian(value),
              ),
              const Divider(height: 24),
              _buildBatasItem(
                context: context,
                icon: Icons.view_week,
                title: 'Mingguan',
                value: batasProvider.batasMingguan,
                color: AppColors.primary,
                onChanged: (value) => batasProvider.setBatasMingguan(value),
              ),
              const Divider(height: 24),
              _buildBatasItem(
                context: context,
                icon: Icons.calendar_month,
                title: 'Bulanan',
                value: batasProvider.batasBulanan,
                color: AppColors.success,
                onChanged: (value) => batasProvider.setBatasBulanan(value),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBatasItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required int value,
    required Color color,
    required Function(int) onChanged,
  }) {
    final controller = TextEditingController(text: value.toString());

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.captionContext(context)),
              const SizedBox(height: 4),
              Text(
                'Rp ${formatCurrency(value)}',
                style: AppTextStyles.bodyContext(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 18),
          color: AppColors.primary,
          onPressed: () => _showEditBatasDialog(
            context: context,
            title: 'Atur Batas $title',
            controller: controller,
            color: color,
            onSave: onChanged,
          ),
        ),
      ],
    );
  }

  void _showEditBatasDialog({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required Color color,
    required Function(int) onSave,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).cardColor,
        title: Text(title, style: AppTextStyles.heading4Context(context)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTextStyles.inputContext(context),
          decoration: InputDecoration(
            prefixText: 'Rp ',
            prefixStyle: AppTextStyles.bodyContext(context).copyWith(color: color),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text) ?? 0;
              if (value > 0) {
                onSave(value);
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAboutItem(
            context: context,
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
                    style: AppTextStyles.bodyContext(context),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 1, indent: 56),
          _buildAboutItem(
            context: context,
            icon: Icons.code_rounded,
            title: 'Versi',
            trailing: Text('1.0.0', style: AppTextStyles.bodySmallContext(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.forBrightness(context, AppColors.greyLight, AppColors.greyLightDark),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.grey, size: 22),
      ),
      title: Text(title, style: AppTextStyles.bodyContext(context)),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.grey),
      onTap: onTap,
    );
  }
}
