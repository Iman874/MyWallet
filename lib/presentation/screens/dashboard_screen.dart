import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaksi_provider.dart';
import '../widgets/saldo_card.dart';
import '../widgets/ringkasan_harian_card.dart';
import '../widgets/transaksi_terbaru_list.dart';
import '../widgets/empty_state_widget.dart';
import 'tambah_transaksi_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UangKu'),
      ),
      body: Consumer<TransaksiProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.list.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadAll(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SaldoCard(saldo: provider.saldo),
                    const SizedBox(height: 16),
                    RingkasanHarianCard(
                      pemasukan: provider.ringkasanHarian['pemasukan'] ?? 0,
                      pengeluaran: provider.ringkasanHarian['pengeluaran'] ?? 0,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Transaksi Terbaru',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (provider.list.isEmpty)
                      const EmptyStateWidget()
                    else
                      TransaksiTerbaruList(transaksiList: provider.list),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahTransaksiScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
