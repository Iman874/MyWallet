import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaksi_provider.dart';
import '../widgets/transaksi_list_item.dart';

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
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: Column(
        children: [
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

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<int>(
              value: _selectedMonth,
              isExpanded: true,
              items: List.generate(12, (index) {
                return DropdownMenuItem(
                  value: index + 1,
                  child: Text(months[index]),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMonth = value;
                  });
                  context.read<TransaksiProvider>().loadByMonth(_selectedYear, _selectedMonth);
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButton<int>(
              value: _selectedYear,
              isExpanded: true,
              items: List.generate(5, (index) {
                final year = DateTime.now().year - 2 + index;
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedYear = value;
                  });
                  context.read<TransaksiProvider>().loadByMonth(_selectedYear, _selectedMonth);
                }
              },
            ),
          ),
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
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada transaksi di bulan ini',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: provider.list.length,
          itemBuilder: (context, index) {
            return TransaksiListItem(
              transaksi: provider.list[index],
              onTap: () => _showEditDialog(provider.list[index]),
              onDelete: () => _showDeleteDialog(provider.list[index].id!),
            );
          },
        );
      },
    );
  }

  void _showEditDialog(dynamic transaksi) {
    final catatanController = TextEditingController(text: transaksi.catatan ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Catatan'),
        content: TextField(
          controller: catatanController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Masukkan catatan...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TransaksiProvider>().updateCatatan(
                transaksi.id!,
                catatanController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: const Text('Yakin ingin menghapus transaksi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              context.read<TransaksiProvider>().delete(id);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
