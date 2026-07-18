import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaksi_provider.dart';
import '../providers/kategori_provider.dart';
import '../widgets/sticky_header.dart';
import '../widgets/pie_kategori_widget.dart';
import '../widgets/budget_kategori_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/format.dart';
import '../../core/utils/icon_mapper.dart';
import '../../domain/entities/transaksi.dart';
import '../../domain/entities/kategori.dart';

class StatistikScreen extends StatefulWidget {
  const StatistikScreen({super.key});

  @override
  State<StatistikScreen> createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  late int _selectedYear;
  late int _selectedMonth;
  TransaksiType? _selectedJenis;
  String? _selectedKategori;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    context.read<TransaksiProvider>().loadByMonth(_selectedYear, _selectedMonth);
    context.read<KategoriProvider>().loadAll();
  }

  List<Transaksi> _filterList(List<Transaksi> list) {
    var filtered = list;
    if (_selectedJenis != null) {
      filtered = filtered.where((t) => t.tipe == _selectedJenis).toList();
    }
    if (_selectedKategori != null) {
      filtered = filtered.where((t) => t.kategori == _selectedKategori).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          StickyHeader(
            title: 'Statistik',
            subtitle: 'Ringkasan keuangan',
            trailing: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.bar_chart_rounded,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                size: 22,
              ),
            ),
          ),
          _buildFilter(context),
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter(BuildContext context) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  context: context,
                  label: 'Bulan',
                  value: months[_selectedMonth - 1],
                  icon: Icons.calendar_today,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => _buildMonthPicker(context, months),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  context: context,
                  label: 'Tahun',
                  value: _selectedYear.toString(),
                  icon: Icons.calendar_today,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => _buildYearPicker(context),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  context: context,
                  label: 'Tipe',
                  value: _selectedJenis == null ? 'Semua' : (_selectedJenis == TransaksiType.pemasukan ? 'Pemasukan' : 'Pengeluaran'),
                  icon: Icons.swap_vert_rounded,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => _buildJenisPicker(context),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  context: context,
                  label: 'Kategori',
                  value: _selectedKategori ?? 'Semua',
                  icon: Icons.category_rounded,
                  onTap: _selectedJenis == null ? null : () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => _buildKategoriPicker(context),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDisabled
              ? Theme.of(context).cardColor.withValues(alpha: 0.5)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: isDisabled ? AppColors.grey : AppColors.primary, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.captionContext(context).copyWith(fontSize: 10)),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyContext(context).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: isDisabled ? AppColors.grey : null,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: isDisabled ? AppColors.grey : AppColors.primary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthPicker(BuildContext context, List<String> months) {
    final fullMonths = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Pilih Bulan', style: AppTextStyles.heading4Context(context)),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                return ListTile(
                  title: Text(fullMonths[index], style: AppTextStyles.bodyContext(context)),
                  trailing: _selectedMonth == month
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedMonth = month;
                    });
                    _loadData();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearPicker(BuildContext context) {
    final currentYear = DateTime.now().year;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Pilih Tahun', style: AppTextStyles.heading4Context(context)),
          const SizedBox(height: 16),
          ...List.generate(5, (index) {
            final year = currentYear - 2 + index;
            return ListTile(
              title: Text(year.toString(), style: AppTextStyles.bodyContext(context)),
              trailing: _selectedYear == year
                  ? const Icon(Icons.check_circle, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedYear = year;
                });
                _loadData();
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildJenisPicker(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Pilih Tipe', style: AppTextStyles.heading4Context(context)),
          const SizedBox(height: 16),
          ...['Semua', 'Pemasukan', 'Pengeluaran'].map((jenis) {
            final value = jenis == 'Semua'
                ? null
                : (jenis == 'Pemasukan' ? TransaksiType.pemasukan : TransaksiType.pengeluaran);
            return ListTile(
              title: Text(jenis, style: AppTextStyles.bodyContext(context)),
              trailing: _selectedJenis == value
                  ? const Icon(Icons.check_circle, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedJenis = value;
                  _selectedKategori = null;
                });
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildKategoriPicker(BuildContext context) {
    final kategoriProvider = context.watch<KategoriProvider>();
    final listKategori = _selectedJenis == TransaksiType.pemasukan
        ? kategoriProvider.listPemasukan
        : kategoriProvider.listPengeluaran;

    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Pilih Kategori', style: AppTextStyles.heading4Context(context)),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listKategori.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: Text('Semua', style: AppTextStyles.bodyContext(context)),
                    trailing: _selectedKategori == null
                        ? const Icon(Icons.check_circle, color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedKategori = null;
                      });
                      Navigator.pop(context);
                    },
                  );
                }
                final kategori = listKategori[index - 1];
                final katIcon = iconFromName(kategori.icon);
                return ListTile(
                  leading: katIcon != null
                      ? Icon(katIcon, color: Color(int.parse('FF${kategori.warna.replaceFirst('#', '')}', radix: 16)), size: 24)
                      : Text(kategori.icon, style: const TextStyle(fontSize: 22)),
                  title: Text(kategori.nama, style: AppTextStyles.bodyContext(context)),
                  trailing: _selectedKategori == kategori.nama
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedKategori = kategori.nama;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Consumer2<TransaksiProvider, KategoriProvider>(
      builder: (context, transaksiProvider, kategoriProvider, child) {
        if (transaksiProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final filtered = _filterList(transaksiProvider.list);

        final kategoriMap = <String, Kategori>{};
        for (final k in kategoriProvider.list) {
          kategoriMap[k.nama] = k;
        }

        final pemasukan = filtered
            .where((t) => t.tipe == TransaksiType.pemasukan)
            .fold(0, (sum, t) => sum + t.jumlah);
        final pengeluaran = filtered
            .where((t) => t.tipe == TransaksiType.pengeluaran)
            .fold(0, (sum, t) => sum + t.jumlah);
        final selisih = pemasukan - pengeluaran;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRingkasan(context, pemasukan, pengeluaran, selisih),
              const SizedBox(height: 20),
              _buildChart(context, pemasukan, pengeluaran),
              const SizedBox(height: 20),
              _buildPieKategori(context, filtered, kategoriProvider.list),
              const SizedBox(height: 20),
              BudgetKategoriWidget(
                transaksi: filtered,
                listKategori: kategoriProvider.list,
                year: _selectedYear,
                month: _selectedMonth,
              ),
              const SizedBox(height: 20),
              _buildDetailTransaksi(context, filtered, kategoriMap),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRingkasan(BuildContext context, int pemasukan, int pengeluaran, int selisih) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ringkasan', style: AppTextStyles.heading4Context(context)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRingkasanItem(
                context: context,
                label: 'Pemasukan',
                amount: pemasukan,
                color: AppColors.success,
                icon: Icons.arrow_downward,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRingkasanItem(
                context: context,
                label: 'Pengeluaran',
                amount: pengeluaran,
                color: AppColors.error,
                icon: Icons.arrow_upward,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildRingkasanItem(
          context: context,
          label: 'Selisih',
          amount: selisih,
          color: selisih >= 0 ? AppColors.success : AppColors.error,
          icon: selisih >= 0 ? Icons.trending_up : Icons.trending_down,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildRingkasanItem({
    required BuildContext context,
    required String label,
    required int amount,
    required Color color,
    required IconData icon,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.captionContext(context).copyWith(fontSize: 11)),
                const SizedBox(height: 4),
                Text(
                  'Rp ${formatCurrency(amount)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.jumlahContext(context).copyWith(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, int pemasukan, int pengeluaran) {
    final maxValue = pemasukan > pengeluaran ? pemasukan : pengeluaran;
    final pemasukanWidth = maxValue > 0 ? (pemasukan / maxValue) : 0.0;
    final pengeluaranWidth = maxValue > 0 ? (pengeluaran / maxValue) : 0.0;

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
          Text('Perbandingan', style: AppTextStyles.heading4Context(context)),
          const SizedBox(height: 16),
          _buildBarChart(context, 'Pemasukan', pemasukanWidth, AppColors.success, pemasukan),
          const SizedBox(height: 12),
          _buildBarChart(context, 'Pengeluaran', pengeluaranWidth, AppColors.error, pengeluaran),
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, String label, double width, Color color, int amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.captionContext(context)),
            Flexible(
              child: Text(
                'Rp ${formatCurrency(amount)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmallContext(context).copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(5),
          ),
          child: FractionallySizedBox(
            widthFactor: width.toDouble(),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildPieKategori(BuildContext context, List<Transaksi> list, List<Kategori> listKategori) {
    final warnaKategori = <String, String>{};
    for (final k in listKategori) {
      warnaKategori[k.nama] = k.warna;
    }
    return PieKategoriWidget(
      transaksi: list,
      warnaKategori: warnaKategori,
    );
  }
  Widget _buildDetailTransaksi(BuildContext context, List<Transaksi> list, Map<String, Kategori> kategoriMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Detail Transaksi', style: AppTextStyles.heading4Context(context)),
        const SizedBox(height: 12),
        if (list.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
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
                'Tidak ada transaksi',
                style: AppTextStyles.bodySmallContext(context),
              ),
            ),
          )
        else
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.38,
            ),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: list.map((transaksi) {
              final kat = kategoriMap[transaksi.kategori];
              final iconBg = kat != null
                  ? Color(int.parse('FF${kat.warna.replaceFirst('#', '')}', radix: 16)).withValues(alpha: 0.15)
                  : (transaksi.tipe == TransaksiType.pemasukan
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1));
              return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: kat?.icon != null
                        ? _buildStatistikIcon(kat!.icon)
                        : Icon(
                            transaksi.tipe == TransaksiType.pemasukan
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: transaksi.tipe == TransaksiType.pemasukan
                                ? AppColors.success
                                : AppColors.error,
                            size: 14,
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaksi.kategori,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyContext(context).copyWith(fontWeight: FontWeight.w500),
                        ),
                        if (transaksi.catatan != null && transaksi.catatan!.isNotEmpty)
                          Text(
                            transaksi.catatan!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.captionContext(context),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${transaksi.tipe == TransaksiType.pemasukan ? '+' : '-'} Rp ${formatCurrency(transaksi.jumlah)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.jumlahContext(context).copyWith(
                      color: transaksi.tipe == TransaksiType.pemasukan
                          ? AppColors.success
                          : AppColors.error,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
            }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildStatistikIcon(String iconName) {
    final iconData = iconFromName(iconName);
    if (iconData != null) {
      return Icon(iconData, size: 16);
    }
    return SizedBox(
      width: 16, height: 16,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(iconName, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}



