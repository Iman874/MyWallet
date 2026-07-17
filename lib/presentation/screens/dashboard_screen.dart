import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaksi_provider.dart';
import '../widgets/gradient_header.dart';
import '../widgets/modern_card.dart';
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
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Hero Header (fixed 200px)
          GradientHeader(
            height: 200,
            title: 'UangKu',
            subtitle: 'Kelola keuanganmu dengan mudah',
            trailing: const Icon(
              Icons.notifications_outlined,
              color: AppColors.white,
              size: 22,
            ),
          ),

          // 2. Balance Card (floating, positioned at top: 120)
          Positioned(
            top: 120,
            left: 24,
            right: 24,
            child: Consumer<TransaksiProvider>(
              builder: (context, provider, child) {
                return _buildSaldoCard(provider.saldo);
              },
            ),
          ),

          // 3. Body (scrollable, starts AFTER balance card)
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 290),
              child: Consumer<TransaksiProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      // 40px spacing after card
                      const SizedBox(height: 40),
                      _buildRingkasanHarian(
                        provider.ringkasanHarian['pemasukan'] ?? 0,
                        provider.ringkasanHarian['pengeluaran'] ?? 0,
                      ),
                      const SizedBox(height: 24),
                      _buildTransaksiTerbaru(context, provider),
                      const SizedBox(height: 100),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // 5. FAB with proper bottom spacing
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
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
    );
  }

  Widget _buildSaldoCard(int saldo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F8CFF), Color(0xFF2F6BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F6BFF).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Wallet icon background
          Positioned(
            right: 0,
            top: 0,
            child: Opacity(
              opacity: 0.12,
              child: Icon(
                Icons.account_balance_wallet,
                color: AppColors.white,
                size: 90,
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
              const SizedBox(height: 8),
              Text(
                'Rp ${saldo.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                style: AppTextStyles.saldo.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
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
    return ModernCard(
      child: Column(
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
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required int amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 14),
              ),
              const SizedBox(width: 8),
              Text(label, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 10),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('Transaksi Terbaru', style: AppTextStyles.heading4),
        ),
        const SizedBox(height: 12),
        if (provider.list.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: EmptyStateWidget(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Belum ada transaksi',
              subtitle: 'Mulai catat keuanganmu sekarang',
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: provider.list.take(5).map(
                (transaksi) => TransaksiListItem(transaksi: transaksi),
              ).toList(),
            ),
          ),
      ],
    );
  }
}
