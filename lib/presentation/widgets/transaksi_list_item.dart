import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/transaksi.dart';

class TransaksiListItem extends StatelessWidget {
  final Transaksi transaksi;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransaksiListItem({
    super.key,
    required this.transaksi,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final isPemasukan = transaksi.tipe == TransaksiType.pemasukan;
    final color = isPemasukan ? AppColors.success : AppColors.error;
    final icon = isPemasukan ? Icons.arrow_upward : Icons.arrow_downward;
    final prefix = isPemasukan ? '+' : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          transaksi.kategori,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMM yyyy').format(transaksi.tanggal),
              style: AppTextStyles.caption.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            if (transaksi.catatan != null && transaksi.catatan!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                transaksi.catatan!,
                style: AppTextStyles.caption.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$prefix${formatter.format(transaksi.jumlah)}',
              style: AppTextStyles.jumlah.copyWith(color: color),
            ),
            if (onEdit != null) ...[
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: AppColors.primary,
                onPressed: onEdit,
              ),
            ],
            if (onDelete != null) ...[
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: AppColors.error,
                onPressed: onDelete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
