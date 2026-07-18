import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaksi_provider.dart';
import '../widgets/sticky_header.dart';
import '../widgets/transaksi_list_item.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_decorations.dart';
import '../providers/toast_provider.dart';
import '../../domain/entities/transaksi.dart';
import '../../core/utils/format.dart';
import 'detail_transaksi_screen.dart';
import 'tambah_transaksi_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
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
          // Sticky Header
          StickyHeader(
            title: 'Riwayat',
            subtitle: 'Lihat semua transaksimu',
            trailing: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                size: 22,
              ),
            ),
          ),
          // Filter
          _buildFilter(),
          // Content
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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.55,
      ),
      padding: const EdgeInsets.all(20),
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

        if (provider.list.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long,
                      size: 60,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Belum ada transaksi\ndi bulan ini',
                    style: AppTextStyles.heading4.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Coba pilih bulan atau tahun lainnya\nuntuk melihat riwayat transaksi.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
          itemCount: provider.list.length,
          itemBuilder: (context, index) {
            final item = provider.list[index];
            return TransaksiListItem(
              transaksi: item,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailTransaksiScreen(transaksi: item),
                  ),
                );
              },
              onEdit: () => _showEditDialog(item),
              onDelete: () => _showDeleteDialog(item),
            );
          },
        );
      },
    );
  }

  void _showEditDialog(Transaksi transaksi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TambahTransaksiScreen(transaksi: transaksi),
      ),
    );
  }

  void _showDeleteDialog(Transaksi item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Hapus Transaksi', style: AppTextStyles.heading4),
        content: Text('Yakin ingin menghapus transaksi ini?', style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: AppDecorations.errorButtonStyle,
            onPressed: () {
              context.read<TransaksiProvider>().delete(item.id!);
              context.read<ToastProvider>().showSuccess(
                'Transaksi berhasil dihapus',
                '${item.kategori} — ${formatCurrencyWithPrefix(item.jumlah)}',
              );
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
