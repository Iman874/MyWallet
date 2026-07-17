import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_decorations.dart';

class SaldoCard extends StatelessWidget {
  final int saldo;

  const SaldoCard({super.key, required this.saldo});

  @override
  Widget build(BuildContext context) {
    final formattedSaldo = NumberFormat.currency(
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(saldo);

    final color = saldo > 0
        ? AppColors.success
        : saldo < 0
            ? AppColors.error
            : AppColors.grey;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: AppDecorations.saldoCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo Terkini',
            style: AppTextStyles.body.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formattedSaldo,
            style: AppTextStyles.saldo.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
