import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/kategori_provider.dart';
import '../widgets/sticky_header.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/kategori.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  int _selectedTab = 0; // 0 = Pengeluaran, 1 = Pemasukan

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KategoriProvider>().loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          StickyHeader(
            title: 'Kategori',
            subtitle: 'Kelola kategori transaksi',
            trailing: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.category_outlined,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                size: 22,
              ),
            ),
          ),
          _buildTabBar(context),
          Expanded(
            child: _buildContent(),
          ),
        ],
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
            onPressed: () => _showAddDialog(),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add, color: AppColors.white, size: 28),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildTab(
                label: 'Pengeluaran',
                icon: Icons.arrow_downward,
                color: AppColors.error,
                isSelected: _selectedTab == 0,
                onTap: () => setState(() => _selectedTab = 0),
              ),
            ),
            Expanded(
              child: _buildTab(
                label: 'Pemasukan',
                icon: Icons.arrow_upward,
                color: AppColors.success,
                isSelected: _selectedTab == 1,
                onTap: () => setState(() => _selectedTab = 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : AppColors.grey, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<KategoriProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = _selectedTab == 0 ? provider.listPengeluaran : provider.listPemasukan;

        if (list.isEmpty) {
          return Center(
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
                    Icons.category_outlined,
                    size: 60,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada kategori',
                  style: AppTextStyles.heading4Context(context).copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final kategori = list[index];
            return _buildKategoriItem(kategori);
          },
        );
      },
    );
  }

  Widget _buildKategoriItem(Kategori kategori) {
    final color = Color(int.parse('FF${kategori.warna.replaceAll('#', '')}', radix: 16));

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_getIcon(kategori.icon), color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kategori.nama,
                  style: AppTextStyles.bodyContext(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (kategori.isDefault)
                  Text(
                    'Default',
                    style: AppTextStyles.captionContext(context).copyWith(
                      color: AppColors.primary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          if (!kategori.isDefault) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              color: AppColors.primary,
              onPressed: () => _showEditDialog(kategori),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: AppColors.error,
              onPressed: () => _showDeleteDialog(kategori),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              color: AppColors.primary,
              onPressed: () => _showEditDialog(kategori),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }

  IconData _getIcon(String iconName) {
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

  void _showAddDialog() {
    final namaController = TextEditingController();
    String selectedIcon = 'category';
    String selectedColor = '#6B7280';
    String selectedTipe = _selectedTab == 0 ? 'pengeluaran' : 'pemasukan';

    final icons = [
      {'name': 'attach_money', 'icon': Icons.attach_money},
      {'name': 'restaurant', 'icon': Icons.restaurant},
      {'name': 'directions_car', 'icon': Icons.directions_car},
      {'name': 'sports_esports', 'icon': Icons.sports_esports},
      {'name': 'category', 'icon': Icons.category},
      {'name': 'shopping_cart', 'icon': Icons.shopping_cart},
      {'name': 'home', 'icon': Icons.home},
      {'name': 'health_and_safety', 'icon': Icons.health_and_safety},
    ];

    final colors = [
      '#22C55E', '#EF4444', '#4F8CFF', '#A855F7',
      '#F59E0B', '#EC4899', '#6B7280', '#14B8A6',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Theme.of(context).cardColor,
          title: Text('Tambah Kategori', style: AppTextStyles.heading4Context(context)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: namaController,
                  style: AppTextStyles.inputContext(context),
                  decoration: InputDecoration(
                    hintText: 'Nama kategori',
                    hintStyle: AppTextStyles.bodyContext(context).copyWith(color: AppColors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Tipe', style: AppTextStyles.labelContext(context)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setDialogState(() => selectedTipe = 'pengeluaran'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedTipe == 'pengeluaran'
                                ? AppColors.error.withValues(alpha: 0.15)
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedTipe == 'pengeluaran' ? AppColors.error : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_downward, size: 14, color: AppColors.error),
                              const SizedBox(width: 4),
                              Text('Pengeluaran', style: TextStyle(
                                fontSize: 12,
                                color: selectedTipe == 'pengeluaran' ? AppColors.error : AppColors.grey,
                                fontWeight: FontWeight.w500,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setDialogState(() => selectedTipe = 'pemasukan'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedTipe == 'pemasukan'
                                ? AppColors.success.withValues(alpha: 0.15)
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedTipe == 'pemasukan' ? AppColors.success : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_upward, size: 14, color: AppColors.success),
                              const SizedBox(width: 4),
                              Text('Pemasukan', style: TextStyle(
                                fontSize: 12,
                                color: selectedTipe == 'pemasukan' ? AppColors.success : AppColors.grey,
                                fontWeight: FontWeight.w500,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Icon', style: AppTextStyles.labelContext(context)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: icons.map((icon) {
                    final isSelected = selectedIcon == icon['name'];
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedIcon = icon['name'] as String),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(6),
                          border: isSelected ? Border.all(color: AppColors.primary) : null,
                        ),
                        child: Icon(
                          icon['icon'] as IconData,
                          color: isSelected ? AppColors.primary : AppColors.grey,
                          size: 18,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text('Warna', style: AppTextStyles.labelContext(context)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: colors.map((color) {
                    final isSelected = selectedColor == color;
                    final colorValue = Color(int.parse('FF${color.replaceAll('#', '')}', radix: 16));
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedColor = color),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: colorValue,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimary,
                                  width: 2,
                                )
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: AppTextStyles.bodyContext(context).copyWith(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                if (namaController.text.isNotEmpty) {
                  context.read<KategoriProvider>().add(
                    Kategori(
                      nama: namaController.text,
                      icon: selectedIcon,
                      warna: selectedColor,
                      tipe: selectedTipe,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Kategori kategori) {
    final namaController = TextEditingController(text: kategori.nama);
    final batasController = TextEditingController(
      text: kategori.batas != null ? kategori.batas.toString() : '',
    );
    String selectedIcon = kategori.icon;
    String selectedColor = kategori.warna;
    String selectedTipe = kategori.tipe;

    final icons = [
      {'name': 'attach_money', 'icon': Icons.attach_money},
      {'name': 'restaurant', 'icon': Icons.restaurant},
      {'name': 'directions_car', 'icon': Icons.directions_car},
      {'name': 'sports_esports', 'icon': Icons.sports_esports},
      {'name': 'category', 'icon': Icons.category},
      {'name': 'shopping_cart', 'icon': Icons.shopping_cart},
      {'name': 'home', 'icon': Icons.home},
      {'name': 'health_and_safety', 'icon': Icons.health_and_safety},
    ];

    final colors = [
      '#22C55E', '#EF4444', '#4F8CFF', '#A855F7',
      '#F59E0B', '#EC4899', '#6B7280', '#14B8A6',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Theme.of(context).cardColor,
          title: Text('Edit Kategori', style: AppTextStyles.heading4Context(context)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: namaController,
                  style: AppTextStyles.inputContext(context),
                  decoration: InputDecoration(
                    hintText: 'Nama kategori',
                    hintStyle: AppTextStyles.bodyContext(context).copyWith(color: AppColors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Tipe', style: AppTextStyles.labelContext(context)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setDialogState(() => selectedTipe = 'pengeluaran'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedTipe == 'pengeluaran'
                                ? AppColors.error.withValues(alpha: 0.15)
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedTipe == 'pengeluaran' ? AppColors.error : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_downward, size: 14, color: AppColors.error),
                              const SizedBox(width: 4),
                              Text('Pengeluaran', style: TextStyle(
                                fontSize: 12,
                                color: selectedTipe == 'pengeluaran' ? AppColors.error : AppColors.grey,
                                fontWeight: FontWeight.w500,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setDialogState(() => selectedTipe = 'pemasukan'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedTipe == 'pemasukan'
                                ? AppColors.success.withValues(alpha: 0.15)
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedTipe == 'pemasukan' ? AppColors.success : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_upward, size: 14, color: AppColors.success),
                              const SizedBox(width: 4),
                              Text('Pemasukan', style: TextStyle(
                                fontSize: 12,
                                color: selectedTipe == 'pemasukan' ? AppColors.success : AppColors.grey,
                                fontWeight: FontWeight.w500,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Icon', style: AppTextStyles.labelContext(context)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: icons.map((icon) {
                    final isSelected = selectedIcon == icon['name'];
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedIcon = icon['name'] as String),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(6),
                          border: isSelected ? Border.all(color: AppColors.primary) : null,
                        ),
                        child: Icon(
                          icon['icon'] as IconData,
                          color: isSelected ? AppColors.primary : AppColors.grey,
                          size: 18,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text('Warna', style: AppTextStyles.labelContext(context)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: colors.map((color) {
                    final isSelected = selectedColor == color;
                    final colorValue = Color(int.parse('FF${color.replaceAll('#', '')}', radix: 16));
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedColor = color),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: colorValue,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimary,
                                  width: 2,
                                )
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text('Batas Budget (opsional)', style: AppTextStyles.labelContext(context)),
                const SizedBox(height: 6),
                TextField(
                  controller: batasController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: AppTextStyles.inputContext(context),
                  decoration: InputDecoration(
                    hintText: 'Kosongkan jika tanpa batas',
                    hintStyle: AppTextStyles.bodyContext(context).copyWith(color: AppColors.grey),
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: AppTextStyles.bodyContext(context).copyWith(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                if (namaController.text.isNotEmpty) {
                  final batasText = batasController.text.trim();
                  context.read<KategoriProvider>().update(
                    kategori.copyWith(
                      nama: namaController.text,
                      icon: selectedIcon,
                      warna: selectedColor,
                      tipe: selectedTipe,
                      batas: batasText.isEmpty ? null : int.tryParse(batasText),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(Kategori kategori) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Hapus Kategori', style: AppTextStyles.heading4Context(context)),
        content: Text(
          'Yakin ingin menghapus "${kategori.nama}"?',
          style: AppTextStyles.bodyContext(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: AppTextStyles.bodyContext(context).copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            onPressed: () {
              context.read<KategoriProvider>().delete(kategori.id!);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
