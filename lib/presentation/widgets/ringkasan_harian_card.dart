import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RingkasanHarianCard extends StatelessWidget {
  final int pemasukan;
  final int pengeluaran;

  const RingkasanHarianCard({
    super.key,
    required this.pemasukan,
    required this.pengeluaran,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Hari Ini',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    label: 'Pemasukan',
                    amount: formatter.format(pemasukan),
                    icon: Icons.arrow_downward,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryItem(
                    label: 'Pengeluaran',
                    amount: formatter.format(pengeluaran),
                    icon: Icons.arrow_upward,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: AppTextStyles.jumlah.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
