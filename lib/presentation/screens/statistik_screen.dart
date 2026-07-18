import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaksi_provider.dart';
import '../widgets/sticky_header.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/transaksi.dart';

class StatistikScreen extends StatefulWidget {
  const StatistikScreen({super.key});

  @override
  State<StatistikScreen> createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransaksiProvider>().loadByMonth(_selectedYear, _selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          StickyHeader(
            title: 'Statistik',
            subtitle: 'Ringkasan keuangan bulanan',
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
          _buildFilter(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterDropdown(
              label: 'Bulan',
              value: months[_selectedMonth - 1],
              icon: Icons.calendar_today,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => _buildMonthPicker(months),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFilterDropdown(
              label: 'Tahun',
              value: _selectedYear.toString(),
              icon: Icons.calendar_today,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => _buildYearPicker(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.caption.copyWith(fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthPicker(List<String> months) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Pilih Bulan', style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                return ListTile(
                  title: Text(months[index]),
                  trailing: _selectedMonth == month
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedMonth = month;
                    });
                    context.read<TransaksiProvider>().loadByMonth(_selectedYear, _selectedMonth);
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

  Widget _buildYearPicker() {
    final currentYear = DateTime.now().year;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Pilih Tahun', style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          ...List.generate(5, (index) {
            final year = currentYear - 2 + index;
            return ListTile(
              title: Text(year.toString()),
              trailing: _selectedYear == year
                  ? const Icon(Icons.check_circle, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedYear = year;
                });
                context.read<TransaksiProvider>().loadByMonth(_selectedYear, _selectedMonth);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<TransaksiProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final pemasukan = provider.ringkasanHarian['pemasukan'] ?? 0;
        final pengeluaran = provider.ringkasanHarian['pengeluaran'] ?? 0;
        final selisih = pemasukan - pengeluaran;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan
              _buildRingkasan(pemasukan, pengeluaran, selisih),
              const SizedBox(height: 24),
              // Chart placeholder
              _buildChart(pemasukan, pengeluaran),
              const SizedBox(height: 24),
              // Detail transaksi
              _buildDetailTransaksi(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRingkasan(int pemasukan, int pengeluaran, int selisih) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ringkasan', style: AppTextStyles.heading4),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildRingkasanItem(
                label: 'Pemasukan',
                amount: pemasukan,
                color: AppColors.success,
                icon: Icons.arrow_downward,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRingkasanItem(
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
    required String label,
    required int amount,
    required Color color,
    required IconData icon,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(
                  'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                  style: AppTextStyles.jumlah.copyWith(
                    color: color,
                    fontSize: 18,
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

  Widget _buildChart(int pemasukan, int pengeluaran) {
    final maxValue = pemasukan > pengeluaran ? pemasukan : pengeluaran;
    final pemasukanWidth = maxValue > 0 ? (pemasukan / maxValue) : 0.0;
    final pengeluaranWidth = maxValue > 0 ? (pengeluaran / maxValue) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Perbandingan', style: AppTextStyles.heading4),
          const SizedBox(height: 20),
          _buildBarChart('Pemasukan', pemasukanWidth, AppColors.success, pemasukan),
          const SizedBox(height: 16),
          _buildBarChart('Pengeluaran', pengeluaranWidth, AppColors.error, pengeluaran),
        ],
      ),
    );
  }

  Widget _buildBarChart(String label, double width, Color color, int amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(
              'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: FractionallySizedBox(
            widthFactor: width.toDouble(),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailTransaksi(TransaksiProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Detail Transaksi', style: AppTextStyles.heading4),
        const SizedBox(height: 16),
        if (provider.list.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
                'Tidak ada transaksi di bulan ini',
                style: AppTextStyles.bodySmall,
              ),
            ),
          )
        else
          ...provider.list.map(
            (transaksi) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: transaksi.tipe == TransaksiType.pemasukan
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      transaksi.tipe == TransaksiType.pemasukan
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: transaksi.tipe == TransaksiType.pemasukan
                          ? AppColors.success
                          : AppColors.error,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaksi.kategori,
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          transaksi.catatan ?? '-',
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${transaksi.tipe == TransaksiType.pemasukan ? '+' : '-'} Rp ${transaksi.jumlah.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                    style: AppTextStyles.jumlah.copyWith(
                      color: transaksi.tipe == TransaksiType.pemasukan
                          ? AppColors.success
                          : AppColors.error,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
