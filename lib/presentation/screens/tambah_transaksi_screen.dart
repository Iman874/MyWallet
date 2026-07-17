import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaksi_provider.dart';
import '../../domain/entities/transaksi.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class TambahTransaksiScreen extends StatefulWidget {
  const TambahTransaksiScreen({super.key});

  @override
  State<TambahTransaksiScreen> createState() => _TambahTransaksiScreenState();
}

class _TambahTransaksiScreenState extends State<TambahTransaksiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();
  final _catatanController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedKategori = 'Makan';
  TransaksiType _selectedTipe = TransaksiType.pemasukan;

  final List<String> _kategoriList = [
    'Gaji',
    'Makan',
    'Transportasi',
    'Hiburan',
    'Lainnya',
  ];

  IconData _getKategoriIcon(String kategori) {
    switch (kategori) {
      case 'Gaji':
        return Icons.attach_money;
      case 'Makan':
        return Icons.restaurant;
      case 'Transportasi':
        return Icons.directions_car;
      case 'Hiburan':
        return Icons.sports_esports;
      default:
        return Icons.category;
    }
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final jumlah = int.parse(_jumlahController.text);
    final catatan = _catatanController.text.isEmpty
        ? null
        : _catatanController.text;

    final transaksi = Transaksi(
      jumlah: jumlah,
      tanggal: _selectedDate,
      kategori: _selectedKategori,
      catatan: catatan,
      tipe: _selectedTipe,
    );

    await context.read<TransaksiProvider>().add(transaksi);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: Consumer<TransaksiProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Jumlah
                  TextFormField(
                    controller: _jumlahController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Jumlah',
                      prefixText: 'Rp ',
                      prefixStyle: AppTextStyles.body.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah wajib diisi';
                      }
                      final jumlah = int.tryParse(value);
                      if (jumlah == null || jumlah <= 0) {
                        return 'Jumlah harus lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tanggal
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: DateFormat('dd MMMM yyyy').format(_selectedDate),
                    ),
                    onTap: _selectDate,
                  ),
                  const SizedBox(height: 16),

                  // Kategori
                  DropdownButtonFormField<String>(
                    initialValue: _selectedKategori,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                    ),
                    items: _kategoriList.map((String kategori) {
                      return DropdownMenuItem<String>(
                        value: kategori,
                        child: Row(
                          children: [
                            Icon(_getKategoriIcon(kategori), size: 20),
                            const SizedBox(width: 8),
                            Text(kategori),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedKategori = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tipe
                  Text('Tipe Transaksi', style: AppTextStyles.body),
                  const SizedBox(height: 8),
                  RadioGroup<TransaksiType>(
                    groupValue: _selectedTipe,
                    onChanged: (value) {
                      setState(() {
                        _selectedTipe = value!;
                      });
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile<TransaksiType>(
                            title: const Text('Pemasukan'),
                            value: TransaksiType.pemasukan,
                            activeColor: AppColors.success,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<TransaksiType>(
                            title: const Text('Pengeluaran'),
                            value: TransaksiType.pengeluaran,
                            activeColor: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Catatan
                  TextFormField(
                    controller: _catatanController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Catatan (opsional)',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Simpan
                  ElevatedButton(
                    onPressed: provider.isLoading ? null : _submit,
                    child: provider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Text('Simpan'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
