import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaksi_provider.dart';
import '../providers/toast_provider.dart';
import '../../domain/entities/transaksi.dart';
import '../widgets/konfirmasi_dialog.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/format.dart';
import 'tambah_transaksi_screen.dart';

class DetailTransaksiScreen extends StatefulWidget {
  final Transaksi transaksi;

  const DetailTransaksiScreen({super.key, required this.transaksi});

  @override
  State<DetailTransaksiScreen> createState() => _DetailTransaksiScreenState();
}

class _DetailTransaksiScreenState extends State<DetailTransaksiScreen> {
  late Transaksi _transaksi;

  @override
  void initState() {
    super.initState();
    _transaksi = widget.transaksi;
  }

  void _refreshTransaksi() {
    final provider = context.read<TransaksiProvider>();
    final found = provider.list.where((t) => t.id == _transaksi.id).toList();
    if (found.isNotEmpty) {
      setState(() {
        _transaksi = found.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPemasukan = _transaksi.tipe == TransaksiType.pemasukan;
    final tipeColor = isPemasukan ? AppColors.success : AppColors.error;
    final tipeLabel = isPemasukan ? 'Pemasukan' : 'Pengeluaran';
    final formatter = NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(context, tipeColor, tipeLabel),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildAmountCard(context, isPemasukan, formatter, tipeColor),
                  const SizedBox(height: 20),
                  _buildInfoSection(context),
                ],
              ),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color tipeColor, String tipeLabel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 48, 16, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tipeColor, tipeColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                'Detail Transaksi',
                style: AppTextStyles.heading3.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tipeLabel,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(BuildContext context, bool isPemasukan, NumberFormat formatter, Color tipeColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        children: [
          Text(
            isPemasukan ? '+${formatter.format(_transaksi.jumlah)}' : '-${formatter.format(_transaksi.jumlah)}',
            style: AppTextStyles.heading1.copyWith(
              fontSize: 32,
              color: tipeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('dd MMMM yyyy, HH:mm').format(_transaksi.tanggal),
            style: AppTextStyles.bodySmallContext(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      width: double.infinity,
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
          Text('Informasi', style: AppTextStyles.heading4Context(context)),
          const SizedBox(height: 16),
          _buildInfoRow(context, Icons.category_outlined, 'Kategori', _transaksi.kategori),
          const Divider(height: 24),
          _buildInfoRow(context, Icons.calendar_today, 'Tanggal', DateFormat('dd MMMM yyyy').format(_transaksi.tanggal)),
          const Divider(height: 24),
          _buildInfoRow(context, Icons.access_time, 'Waktu', DateFormat('HH:mm').format(_transaksi.tanggal)),
          if (_transaksi.catatan != null && _transaksi.catatan!.isNotEmpty) ...[
            const Divider(height: 24),
            _buildInfoRow(context, Icons.notes, 'Catatan', _transaksi.catatan!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.captionContext(context)),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyContext(context).copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showDeleteDialog(context),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Hapus'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _navigateToEdit(context),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToEdit(BuildContext context) async {
    final result = await Navigator.push<Transaksi>(
      context,
      MaterialPageRoute(
        builder: (_) => TambahTransaksiScreen(transaksi: _transaksi),
      ),
    );
    if (result != null) {
      _refreshTransaksi();
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => KonfirmasiDialog(
        title: 'Hapus Transaksi',
        message: 'Yakin ingin menghapus transaksi ini?',
        onConfirm: () {
          context.read<TransaksiProvider>().delete(_transaksi.id!);
          context.read<ToastProvider>().showSuccess(
            'Transaksi berhasil dihapus',
            '${_transaksi.kategori} — ${formatCurrencyWithPrefix(_transaksi.jumlah)}',
          );
          Navigator.of(ctx).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
