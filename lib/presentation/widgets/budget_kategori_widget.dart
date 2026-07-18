import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/format.dart';
import '../../core/utils/icon_mapper.dart';
import '../../domain/entities/kategori.dart';
import '../../domain/entities/transaksi.dart';

class BudgetKategoriWidget extends StatelessWidget {
  final List<Transaksi> transaksi;
  final List<Kategori> listKategori;
  final int year;
  final int month;

  const BudgetKategoriWidget({
    super.key,
    required this.transaksi,
    required this.listKategori,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final withBudget = listKategori
        .where((k) => k.tipe == 'pengeluaran' && k.batas != null && k.batas! > 0)
        .toList();

    if (withBudget.isEmpty) {
      return const SizedBox.shrink();
    }

    final pengeluaranBulan = transaksi.where((t) {
      return t.tipe == TransaksiType.pengeluaran &&
          t.tanggal.year == year &&
          t.tanggal.month == month;
    }).toList();

    final Map<String, int> perKategori = {};
    for (final t in pengeluaranBulan) {
      perKategori[t.kategori] = (perKategori[t.kategori] ?? 0) + t.jumlah;
    }

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Budget Kategori', style: AppTextStyles.heading4Context(context)),
          const SizedBox(height: 12),
          ...withBudget.map((k) {
            final terpakai = perKategori[k.nama] ?? 0;
            final batas = k.batas!;
            final ratio = batas > 0 ? (terpakai / batas).clamp(0.0, 1.0) : 0.0;
            final lewat = terpakai > batas;
            final color = lewat ? AppColors.error : AppColors.primary;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(iconFromName(k.icon) ?? Icons.category, size: 16, color: color),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          k.nama,
                          style: AppTextStyles.bodySmallContext(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Rp ${formatCurrency(terpakai)} / ${formatCurrency(batas)}',
                        style: AppTextStyles.captionContext(context).copyWith(
                          color: lewat ? AppColors.error : AppColors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: AppColors.greyLight,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
