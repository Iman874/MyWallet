import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/icon_mapper.dart';
import '../../domain/entities/transaksi.dart';

class TransaksiListItem extends StatelessWidget {
  final Transaksi transaksi;
  final String? categoryIcon;
  final Color? categoryColor;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransaksiListItem({
    super.key,
    required this.transaksi,
    this.categoryIcon,
    this.categoryColor,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  double _amountFontSize(int amount) {
    if (amount >= 1000000000) return 11;
    if (amount >= 1000000) return 13;
    return 16;
  }

  Color _iconBgColor(BuildContext context) {
    if (categoryColor != null) {
      return categoryColor!.withValues(alpha: 0.15);
    }
    final isPemasukan = transaksi.tipe == TransaksiType.pemasukan;
    final color = isPemasukan ? AppColors.success : AppColors.error;
    return color.withValues(alpha: 0.1);
  }

  Color _iconFgColor() {
    if (categoryColor != null) return categoryColor!;
    return transaksi.tipe == TransaksiType.pemasukan
        ? AppColors.success
        : AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final isPemasukan = transaksi.tipe == TransaksiType.pemasukan;
    final color = isPemasukan ? AppColors.success : AppColors.error;
    final prefix = isPemasukan ? '+' : '-';
    final fontSize = _amountFontSize(transaksi.jumlah);

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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _iconBgColor(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: categoryIcon != null
                    ? _buildCategoryIcon()
                    : Icon(
                        isPemasukan ? Icons.arrow_upward : Icons.arrow_downward,
                        color: _iconFgColor(),
                        size: 20,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaksi.kategori,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('dd MMM yyyy').format(transaksi.tanggal),
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    if (transaksi.catatan != null && transaksi.catatan!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        transaksi.catatan!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 11,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$prefix${formatter.format(transaksi.jumlah)}',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.jumlah.copyWith(
                      color: color,
                      fontSize: fontSize,
                    ),
                  ),
                  if (onEdit != null || onDelete != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (onEdit != null)
                          SizedBox(
                            width: 28, height: 28,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              color: AppColors.primary,
                              onPressed: onEdit,
                            ),
                          ),
                        if (onDelete != null)
                          SizedBox(
                            width: 28, height: 28,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.delete_outline, size: 16),
                              color: AppColors.error,
                              onPressed: onDelete,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    final iconData = iconFromName(categoryIcon);
    if (iconData != null) {
      return Icon(iconData, color: _iconFgColor(), size: 20);
    }
    return SizedBox(
      width: 20, height: 20,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(categoryIcon!, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
