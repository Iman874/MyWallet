import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: AppColors.light,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada transaksi',
              style: AppTextStyles.heading3.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Mulai catat keuanganmu sekarang',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
