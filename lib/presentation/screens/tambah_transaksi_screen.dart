import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaksi_provider.dart';
import '../../domain/entities/transaksi.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_decorations.dart';
import '../widgets/gradient_header.dart';
import '../widgets/pill_button.dart';
import '../widgets/icon_prefix.dart';

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

  final List<Map<String, dynamic>> _kategoriList = [
    {'nama': 'Gaji', 'icon': Icons.attach_money, 'color': AppColors.success},
    {'nama': 'Makan', 'icon': Icons.restaurant, 'color': AppColors.error},
    {'nama': 'Transportasi', 'icon': Icons.directions_car, 'color': AppColors.primary},
    {'nama': 'Hiburan', 'icon': Icons.sports_esports, 'color': AppColors.primaryLight},
    {'nama': 'Lainnya', 'icon': Icons.category, 'color': AppColors.grey},
  ];

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
    final catatan = _catatanController.text.isEmpty ? null : _catatanController.text;

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
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          GradientHeader(
            title: 'Tambah Transaksi',
            trailing: const SizedBox(),
            child: const SizedBox(height: 20),
          ),
          Expanded(
            child: Consumer<TransaksiProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildJumlahField(),
                        const SizedBox(height: 20),
                        _buildTanggalField(),
                        const SizedBox(height: 20),
                        _buildKategoriField(),
                        const SizedBox(height: 20),
                        _buildTipeTransaksi(),
                        const SizedBox(height: 20),
                        _buildCatatanField(),
                        const SizedBox(height: 24),
                        _buildSimpanButton(provider),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJumlahField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jumlah', style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: _jumlahController,
          keyboardType: TextInputType.number,
          style: AppTextStyles.input.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Rp',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
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
      ],
    );
  }

  Widget _buildTanggalField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tanggal', style: AppTextStyles.label),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                IconPrefix(icon: Icons.calendar_today, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    DateFormat('dd MMMM yyyy').format(_selectedDate),
                    style: AppTextStyles.input,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKategoriField() {
    final selectedKategori = _kategoriList.firstWhere(
      (k) => k['nama'] == _selectedKategori,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kategori', style: AppTextStyles.label),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => _buildKategoriBottomSheet(),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                IconPrefix(
                  icon: selectedKategori['icon'],
                  color: selectedKategori['color'],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedKategori,
                    style: AppTextStyles.input,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKategoriBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Pilih Kategori', style: AppTextStyles.heading4),
          const SizedBox(height: 16),
          ..._kategoriList.map(
            (kategori) => ListTile(
              leading: IconPrefix(
                icon: kategori['icon'],
                color: kategori['color'],
              ),
              title: Text(kategori['nama']),
              trailing: _selectedKategori == kategori['nama']
                  ? const Icon(Icons.check_circle, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedKategori = kategori['nama'];
                });
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTipeTransaksi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tipe Transaksi', style: AppTextStyles.label),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: PillButton(
                label: 'Pemasukan',
                icon: Icons.arrow_upward,
                color: AppColors.success,
                isSelected: _selectedTipe == TransaksiType.pemasukan,
                onTap: () {
                  setState(() {
                    _selectedTipe = TransaksiType.pemasukan;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PillButton(
                label: 'Pengeluaran',
                icon: Icons.arrow_downward,
                color: AppColors.error,
                isSelected: _selectedTipe == TransaksiType.pengeluaran,
                onTap: () {
                  setState(() {
                    _selectedTipe = TransaksiType.pengeluaran;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCatatanField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Catatan (opsional)', style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: _catatanController,
          maxLines: 3,
          style: AppTextStyles.input,
          decoration: InputDecoration(
            hintText: 'Tulis catatan transaksi...',
            hintStyle: AppTextStyles.input.copyWith(color: AppColors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpanButton(TransaksiProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: provider.isLoading ? null : _submit,
        style: AppDecorations.primaryFullButtonStyle,
        icon: provider.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : const Icon(Icons.save, color: AppColors.white),
        label: Text(
          provider.isLoading ? 'Menyimpan...' : 'Simpan',
          style: AppTextStyles.button,
        ),
      ),
    );
  }
}
