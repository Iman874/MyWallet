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
        return Column(
          children: [
            _buildBatasCard(
              context: context,
              icon: Icons.today,
              title: 'Harian',
              tag: 'per hari',
              value: batasProvider.batasHarian,
              color: AppColors.error,
              onChanged: (value) => batasProvider.setBatasHarian(value),
            ),
            const SizedBox(height: 12),
            _buildBatasCard(
              context: context,
              icon: Icons.view_week,
              title: 'Mingguan',
              tag: 'per minggu',
              value: batasProvider.batasMingguan,
              color: AppColors.primary,
              onChanged: (value) => batasProvider.setBatasMingguan(value),
            ),
            const SizedBox(height: 12),
            _buildBatasCard(
              context: context,
              icon: Icons.calendar_month,
              title: 'Bulanan',
              tag: 'per bulan',
              value: batasProvider.batasBulanan,
              color: AppColors.success,
              onChanged: (value) => batasProvider.setBatasBulanan(value),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBatasCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String tag,
    required int value,
    required Color color,
    required Function(int) onChanged,
  }) {
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 16, 16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyContext(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rp ${formatCurrency(value)} / $tag',
                    style: AppTextStyles.captionContext(context).copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 32, height: 32,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: AppColors.primary,
                onPressed: () => _showEditBatasDialog(
                  context: context,
                  title: 'Atur Batas $title',
                  currentValue: value,
                  color: color,
                  onSave: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBatasDialog({
    required BuildContext context,
    required String title,
    required int currentValue,
    required Color color,
    required Function(int) onSave,
  }) {
    final controller = TextEditingController(text: currentValue.toString());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).cardColor,
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.edit_outlined, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.heading4Context(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(
                      'Rp',
                      style: AppTextStyles.bodyContext(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatefulBuilder(
                        builder: (context, setDialogState) {
                          return TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: AppTextStyles.inputContext(context).copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) {
                              setDialogState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.text.isNotEmpty && int.tryParse(controller.text) != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '= Rp ${formatCurrency(int.parse(controller.text))}',
                    style: AppTextStyles.captionContext(context).copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Batal', style: AppTextStyles.bodyContext(context)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final value = int.tryParse(controller.text) ?? 0;
                      if (value > 0) {
                        onSave(value);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            iconColor: isDark ? AppColors.primaryLight : AppColors.primary,
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
            iconColor: isDark ? AppColors.greyLightDark : AppColors.textSecondary,
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
    required Color iconColor,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? iconColor.withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: AppTextStyles.bodyContext(context)),
      trailing: trailing ?? Icon(Icons.chevron_right, color: isDark ? Colors.grey : AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
