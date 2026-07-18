import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class KonfirmasiDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final IconData icon;
  final Color confirmColor;
  final VoidCallback? onConfirm;
  final Future<void> Function()? onConfirmAsync;

  const KonfirmasiDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Hapus',
    this.cancelLabel = 'Batal',
    this.icon = Icons.delete_outline,
    this.confirmColor = AppColors.error,
    this.onConfirm,
    this.onConfirmAsync,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).cardColor,
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
        decoration: BoxDecoration(
          color: confirmColor.withValues(alpha: 0.08),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: confirmColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: confirmColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.heading4Context(context).copyWith(
              fontWeight: FontWeight.w600,
            )),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyContext(context).copyWith(
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                  child: Text(cancelLabel, style: AppTextStyles.bodyContext(context)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (onConfirmAsync != null) {
                      await onConfirmAsync!();
                      if (context.mounted) Navigator.pop(context);
                    } else {
                      onConfirm?.call();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(confirmLabel),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
