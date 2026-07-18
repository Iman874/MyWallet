import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/format.dart';
import '../../domain/entities/transaksi.dart';

class PieKategoriWidget extends StatelessWidget {
  final List<Transaksi> transaksi;
  final Map<String, String> warnaKategori;

  const PieKategoriWidget({
    super.key,
    required this.transaksi,
    required this.warnaKategori,
  });

  @override
  Widget build(BuildContext context) {
    final pengeluaran = transaksi
        .where((t) => t.tipe == TransaksiType.pengeluaran)
        .toList();

    final Map<String, int> perKategori = {};
    for (final t in pengeluaran) {
      perKategori[t.kategori] = (perKategori[t.kategori] ?? 0) + t.jumlah;
    }

    final entries = perKategori.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold<int>(0, (sum, e) => sum + e.value);

    if (entries.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
        child: Center(
          child: Text(
            'Tidak ada pengeluaran',
            style: AppTextStyles.bodySmallContext(context),
          ),
        ),
      );
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
          Text('Komposisi Pengeluaran', style: AppTextStyles.heading4Context(context)),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final size = (availableWidth * 0.32).clamp(90.0, 140.0);
              final centerRadius = size * 0.30;
              final sectionRadius = size * 0.34;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size,
                            width: size,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: centerRadius,
                                startDegreeOffset: -90,
                                sections: entries.map((e) {
                                  final color = _colorFromString(
                                    warnaKategori[e.key] ?? '#3B82F6',
                                  );
                                  return PieChartSectionData(
                                    color: color,
                                    value: e.value.toDouble(),
                                    title: '',
                                    radius: sectionRadius,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Total',
                            style: AppTextStyles.captionContext(context).copyWith(
                              fontSize: 11,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 3),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Rp ${formatCurrency(total)}',
                              style: AppTextStyles.jumlahContext(context).copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: size + 34,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: entries.map((e) {
                              final color = _colorFromString(
                                warnaKategori[e.key] ?? '#3B82F6',
                              );
                              final persen = total > 0
                                  ? (e.value / total * 100).toStringAsFixed(1)
                                  : '0';
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        e.key,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.bodySmallContext(context),
                                      ),
                                    ),
                                    Text(
                                      '$persen%',
                                      style: AppTextStyles.captionContext(context).copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _colorFromString(String hex) {
    final clean = hex.replaceFirst('#', '');
    final value = int.tryParse(clean, radix: 16);
    if (value == null) return AppColors.primary;
    return Color(0xFF000000 + value);
  }
}
