import 'package:flutter/material.dart';
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
      backgroundColor: const Color(0xFFF5F7FB),
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

  Widget _buildContent() {
    return Consumer<KategoriProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.list.isEmpty) {
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
                  style: AppTextStyles.heading4.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
          itemCount: provider.list.length,
          itemBuilder: (context, index) {
            final kategori = provider.list[index];
            return _buildKategoriItem(kategori);
          },
        );
      },
    );
  }

  Widget _buildKategoriItem(Kategori kategori) {
    final color = Color(int.parse('FF${kategori.warna.replaceAll('#', '')}', radix: 16));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getIcon(kategori.icon), color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kategori.nama,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (kategori.isDefault)
                  Text(
                    'Default',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          if (!kategori.isDefault) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              color: AppColors.primary,
              onPressed: () => _showEditDialog(kategori),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: AppColors.error,
              onPressed: () => _showDeleteDialog(kategori),
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              color: AppColors.primary,
              onPressed: () => _showEditDialog(kategori),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Tambah Kategori', style: AppTextStyles.heading4),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                    hintText: 'Nama kategori',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Icon', style: AppTextStyles.label),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: icons.map((icon) {
                    final isSelected = selectedIcon == icon['name'];
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = icon['name'] as String;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: AppColors.primary)
                              : null,
                        ),
                        child: Icon(
                          icon['icon'] as IconData,
                          color: isSelected ? AppColors.primary : AppColors.grey,
                          size: 20,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text('Warna', style: AppTextStyles.label),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: colors.map((color) {
                    final isSelected = selectedColor == color;
                    final colorValue = Color(int.parse('FF${color.replaceAll('#', '')}', radix: 16));
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colorValue,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: AppColors.textPrimary, width: 2)
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
              child: Text('Batal', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                if (namaController.text.isNotEmpty) {
                  context.read<KategoriProvider>().add(
                    Kategori(
                      nama: namaController.text,
                      icon: selectedIcon,
                      warna: selectedColor,
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
    String selectedIcon = kategori.icon;
    String selectedColor = kategori.warna;

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Edit Kategori', style: AppTextStyles.heading4),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                    hintText: 'Nama kategori',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Icon', style: AppTextStyles.label),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: icons.map((icon) {
                    final isSelected = selectedIcon == icon['name'];
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = icon['name'] as String;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: AppColors.primary)
                              : null,
                        ),
                        child: Icon(
                          icon['icon'] as IconData,
                          color: isSelected ? AppColors.primary : AppColors.grey,
                          size: 20,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text('Warna', style: AppTextStyles.label),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: colors.map((color) {
                    final isSelected = selectedColor == color;
                    final colorValue = Color(int.parse('FF${color.replaceAll('#', '')}', radix: 16));
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colorValue,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: AppColors.textPrimary, width: 2)
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
              child: Text('Batal', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                if (namaController.text.isNotEmpty) {
                  context.read<KategoriProvider>().update(
                    kategori.copyWith(
                      nama: namaController.text,
                      icon: selectedIcon,
                      warna: selectedColor,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Hapus Kategori', style: AppTextStyles.heading4),
        content: Text(
          'Yakin ingin menghapus "${kategori.nama}"?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
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
