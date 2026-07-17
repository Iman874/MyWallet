import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/transaksi.dart';

class TransaksiListItem extends StatelessWidget {
  final Transaksi transaksi;

  const TransaksiListItem({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final isPemasukan = transaksi.tipe == TransaksiType.pemasukan;
    final color = isPemasukan ? AppColors.success : AppColors.error;
    final icon = isPemasukan ? Icons.arrow_downward : Icons.arrow_upward;
    final prefix = isPemasukan ? '+' : '-';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          transaksi.kategori,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          DateFormat('dd MMM yyyy').format(transaksi.tanggal),
          style: AppTextStyles.caption,
        ),
        trailing: Text(
          '$prefix${formatter.format(transaksi.jumlah)}',
          style: AppTextStyles.jumlah.copyWith(color: color),
        ),
      ),
    );
  }
}
