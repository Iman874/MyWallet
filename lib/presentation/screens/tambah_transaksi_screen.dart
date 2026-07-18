import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaksi_provider.dart';
import '../providers/kategori_provider.dart';
import '../providers/batas_provider.dart';
import '../providers/notifikasi_provider.dart';
import '../providers/toast_provider.dart';
import '../../domain/entities/transaksi.dart';
import '../../domain/entities/kategori.dart';
import '../../domain/services/notifikasi_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/format.dart';

class TambahTransaksiScreen extends StatefulWidget {
  final Transaksi? transaksi;

  const TambahTransaksiScreen({super.key, this.transaksi});

  @override
  State<TambahTransaksiScreen> createState() => _TambahTransaksiScreenState();
}

class _TambahTransaksiScreenState extends State<TambahTransaksiScreen> {
  final _catatanController = TextEditingController();
  final _catatanFocusNode = FocusNode();
  String _amount = '';
  DateTime _selectedDate = DateTime.now();
  String _selectedKategori = 'Makan';
  TransaksiType _selectedTipe = TransaksiType.pemasukan;
  bool _isCatatanFocused = false;
  List<Kategori> _kategoriList = [];

  bool get _isEditMode => widget.transaksi != null;

  @override
  void initState() {
    super.initState();
    _catatanFocusNode.addListener(() {
      setState(() {
        _isCatatanFocused = _catatanFocusNode.hasFocus;
      });
    });
    if (_isEditMode) {
      final t = widget.transaksi!;
      _amount = t.jumlah.toString();
      _selectedDate = t.tanggal;
      _selectedKategori = t.kategori;
      _selectedTipe = t.tipe;
      if (t.catatan != null) {
        _catatanController.text = t.catatan!;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadKategori();
    });
  }

  void _loadKategori() {
    final provider = context.read<KategoriProvider>();
    final list = _selectedTipe == TransaksiType.pemasukan
        ? provider.listPemasukan
        : provider.listPengeluaran;
    if (list.isNotEmpty) {
      setState(() {
        _kategoriList = list;
        if (!_kategoriList.any((k) => k.nama == _selectedKategori)) {
          _selectedKategori = _kategoriList.first.nama;
        }
      });
    }
  }

  @override
  void dispose() {
    _catatanController.dispose();
    _catatanFocusNode.dispose();
    super.dispose();
  }

  void _onNumberTap(String value) {
    HapticFeedback.lightImpact();
    setState(() {
      if (value == 'C') {
        _amount = '';
      } else if (value == '<') {
        if (_amount.isNotEmpty) {
          _amount = _amount.substring(0, _amount.length - 1);
        }
      } else {
        if (_amount.length < 12) {
          _amount += value;
        }
      }
    });
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
    if (_amount.isEmpty || int.tryParse(_amount) == null) return;

    final jumlah = int.parse(_amount);
    if (jumlah <= 0) return;

    final catatan = _catatanController.text.isEmpty ? null : _catatanController.text;

    final transaksi = Transaksi(
      jumlah: jumlah,
      tanggal: _selectedDate,
      kategori: _selectedKategori,
      catatan: catatan,
      tipe: _selectedTipe,
    );

    final transaksiProvider = context.read<TransaksiProvider>();
    final batasProvider = context.read<BatasProvider>();
    final kategoriProvider = context.read<KategoriProvider>();
    final notifikasiProvider = context.read<NotifikasiProvider>();
    final toastProvider = context.read<ToastProvider>();

    if (_isEditMode) {
      final updated = transaksi.copyWith(id: widget.transaksi!.id);
      await transaksiProvider.update(updated);
      if (mounted) {
        toastProvider.showSuccess(
          'Transaksi berhasil diperbarui',
          '${updated.kategori} — ${formatCurrencyWithPrefix(updated.jumlah)}',
        );
        Navigator.pop(context, updated);
      }
    } else {
      await transaksiProvider.add(transaksi);

      if (transaksi.tipe == TransaksiType.pengeluaran) {
        final service = NotifikasiService(
          transaksiProvider: transaksiProvider,
          batasProvider: batasProvider,
          kategoriProvider: kategoriProvider,
          notifikasiProvider: notifikasiProvider,
        );
        await service.cekDanBuatNotifikasi(transaksi);
      }

      if (mounted) {
        toastProvider.showSuccess(
          'Transaksi berhasil ditambahkan',
          '${transaksi.kategori} — ${formatCurrencyWithPrefix(transaksi.jumlah)}',
        );
        Navigator.pop(context);
      }
    }
  }

  String get _formattedAmount {
    if (_amount.isEmpty) return '0';
    final number = int.parse(_amount);
    return formatCurrency(number);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.translucent,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTipeTransaksi(context, isDark),
                      const SizedBox(height: 16),
                      _buildAmountDisplay(context),
                      const SizedBox(height: 16),
                      _buildDateAndCategory(context),
                      const SizedBox(height: 16),
                      _buildCatatanField(context),
                    ],
                  ),
                ),
              ),
            ),
            _buildSimpanButton(),
            if (!_isCatatanFocused) _buildCustomNumpad(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          Text(
            _isEditMode ? 'Edit Transaksi' : 'Tambah Transaksi',
            style: AppTextStyles.heading3Context(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipeTransaksi(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildTipeButton(
            context: context,
            label: 'Pemasukan',
            icon: Icons.arrow_upward,
            color: AppColors.success,
            isSelected: _selectedTipe == TransaksiType.pemasukan,
            isDark: isDark,
            onTap: () {
              setState(() {
                _selectedTipe = TransaksiType.pemasukan;
                _selectedKategori = '';
              });
              _loadKategori();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTipeButton(
            context: context,
            label: 'Pengeluaran',
            icon: Icons.arrow_downward,
            color: AppColors.error,
            isSelected: _selectedTipe == TransaksiType.pengeluaran,
            isDark: isDark,
            onTap: () {
              setState(() {
                _selectedTipe = TransaksiType.pengeluaran;
                _selectedKategori = '';
              });
              _loadKategori();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTipeButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodyContext(context).copyWith(
                fontSize: 13,
                color: isSelected ? color : null,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountDisplay(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
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
            'Jumlah',
            style: AppTextStyles.captionContext(context),
          ),
          const SizedBox(height: 8),
          Text(
            'Rp $_formattedAmount',
            style: AppTextStyles.heading1Context(context).copyWith(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: _selectedTipe == TransaksiType.pemasukan
                  ? AppColors.success
                  : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateAndCategory(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDateChip(context),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCategoryChip(context),
        ),
      ],
    );
  }

  Widget _buildDateChip(BuildContext context) {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tanggal', style: AppTextStyles.captionContext(context).copyWith(fontSize: 10)),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('dd MMM yy').format(_selectedDate),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyContext(context).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getKategoriIcon(String iconName) {
    switch (iconName) {
      case 'attach_money':
        return Icons.attach_money;
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'category':
        return Icons.category;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'home':
        return Icons.home;
      case 'health_and_safety':
        return Icons.health_and_safety;
      default:
        return Icons.category;
    }
  }

  Color _getKategoriColor(String warna) {
    return Color(int.parse('FF${warna.replaceAll('#', '')}', radix: 16));
  }

  Widget _buildCategoryChip(BuildContext context) {
    final selected = _kategoriList.firstWhere(
      (k) => k.nama == _selectedKategori,
      orElse: () => Kategori(nama: _selectedKategori, icon: 'category', warna: '#6B7280'),
    );
    final iconData = _getKategoriIcon(selected.icon);
    final color = _getKategoriColor(selected.warna);

    return GestureDetector(
      onTap: () => _showCategoryPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
        child: Row(
          children: [
            Icon(iconData, color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kategori', style: AppTextStyles.captionContext(context).copyWith(fontSize: 10)),
                  const SizedBox(height: 2),
                  Text(
                    _selectedKategori,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyContext(context).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.55,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pilih Kategori', style: AppTextStyles.heading4Context(context)),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _kategoriList.length,
                itemBuilder: (context, index) {
                  final kategori = _kategoriList[index];
                  final iconData = _getKategoriIcon(kategori.icon);
                  final color = _getKategoriColor(kategori.warna);
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(iconData, color: color, size: 20),
                    ),
                    title: Text(kategori.nama, style: AppTextStyles.bodyContext(context)),
                    trailing: _selectedKategori == kategori.nama
                        ? const Icon(Icons.check_circle, color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() => _selectedKategori = kategori.nama);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCatatanField(BuildContext context) {
    return TextField(
      controller: _catatanController,
      focusNode: _catatanFocusNode,
      maxLines: 2,
      style: AppTextStyles.inputContext(context),
      decoration: InputDecoration(
        hintText: 'Catatan (opsional)',
        hintStyle: AppTextStyles.bodyContext(context).copyWith(color: AppColors.grey),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildSimpanButton() {
    final canSubmit = _amount.isNotEmpty && int.tryParse(_amount) != null && int.parse(_amount) > 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canSubmit ? _submit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.grey,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            'Simpan',
            style: AppTextStyles.button.copyWith(fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomNumpad(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF0F0F0),
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildNumpadKey('1', isDark),
              _buildNumpadKey('2', isDark),
              _buildNumpadKey('3', isDark),
            ],
          ),
          Row(
            children: [
              _buildNumpadKey('4', isDark),
              _buildNumpadKey('5', isDark),
              _buildNumpadKey('6', isDark),
            ],
          ),
          Row(
            children: [
              _buildNumpadKey('7', isDark),
              _buildNumpadKey('8', isDark),
              _buildNumpadKey('9', isDark),
            ],
          ),
          Row(
            children: [
              _buildNumpadKey('C', isDark, isAction: true),
              _buildNumpadKey('0', isDark),
              _buildNumpadKey('<', isDark, isAction: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumpadKey(String value, bool isDark, {bool isAction = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: GestureDetector(
          onTap: () => _onNumberTap(value),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isAction
                  ? (isDark ? AppColors.cardDark : Colors.white.withValues(alpha: 0.8))
                  : (isDark ? AppColors.cardDark : Colors.white),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: value == '<'
                  ? Icon(Icons.backspace_outlined, color: isDark ? Colors.white70 : Colors.black54, size: 20)
                  : Text(
                      value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isAction
                            ? (value == 'C' ? AppColors.error : (isDark ? Colors.white70 : Colors.black54))
                            : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
