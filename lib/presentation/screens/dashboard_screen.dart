import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaksi_provider.dart';
import '../widgets/transaksi_list_item.dart';
import '../widgets/empty_state_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'tambah_transaksi_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Consumer<TransaksiProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.list.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Header: Title + Notification
                  _buildHeader(),
                  const SizedBox(height: 24),
                  // Balance Card
                  _buildSaldoCard(provider.saldo),
                  const SizedBox(height: 24),
                  // Ringkasan Hari Ini
                  _buildRingkasanHarian(
                    provider.ringkasanHarian['pemasukan'] ?? 0,
                    provider.ringkasanHarian['pengeluaran'] ?? 0,
                  ),
                  const SizedBox(height: 24),
                  // Transaksi Terbaru
                  _buildTransaksiTerbaru(context, provider),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 88),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4F8CFF), Color(0xFF2F6BFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2F6BFF).withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TambahTransaksiScreen(),
                ),
              );
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add, color: AppColors.white, size: 28),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UangKu',
              style: AppTextStyles.heading1.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kelola keuanganmu dengan mudah',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildSaldoCard(int saldo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F8CFF), Color(0xFF2F6BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F6BFF).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Wallet icon
          Positioned(
            right: 0,
            top: 0,
            child: Opacity(
              opacity: 0.12,
              child: Icon(
                Icons.account_balance_wallet,
                color: AppColors.white,
                size: 100,
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saldo Terkini',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Rp ${saldo.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                style: AppTextStyles.saldo.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      color: AppColors.white.withValues(alpha: 0.9),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Lihat Detail',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRingkasanHarian(int pemasukan, int pengeluaran) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ringkasan Hari Ini', style: AppTextStyles.heading4),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryItem(
                label: 'Pemasukan',
                amount: pemasukan,
                icon: Icons.arrow_downward,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryItem(
                label: 'Pengeluaran',
                amount: pengeluaran,
                icon: Icons.arrow_upward,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required int amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 10),
              Text(label, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 12),
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
    );
  }

  Widget _buildTransaksiTerbaru(BuildContext context, TransaksiProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Transaksi Terbaru', style: AppTextStyles.heading4),
        const SizedBox(height: 16),
        if (provider.list.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const EmptyStateWidget(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Belum ada transaksi',
              subtitle: 'Mulai catat keuanganmu sekarang',
            ),
          )
        else
          ...provider.list.take(5).map(
            (transaksi) => TransaksiListItem(transaksi: transaksi),
          ),
      ],
    );
  }
}
