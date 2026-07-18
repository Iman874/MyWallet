import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/notifikasi_provider.dart';
import '../widgets/sticky_header.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/notifikasi.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotifikasiProvider>().loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          StickyHeader(
            title: 'Notifikasi',
            subtitle: 'Pemberitahuan batas pemakaian',
            trailing: GestureDetector(
              onTap: _tandaiSemuaDibaca,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.done_all,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<NotifikasiProvider>(
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
                    Icons.notifications_none,
                    size: 60,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada notifikasi',
                  style: AppTextStyles.heading4Context(context).copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Notifikasi akan muncul ketika\npemakaian melebihi batas',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmallContext(context),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          itemCount: provider.list.length,
          itemBuilder: (context, index) {
            final notifikasi = provider.list[index];
            return _buildNotifikasiItem(notifikasi);
          },
        );
      },
    );
  }

  Widget _buildNotifikasiItem(Notifikasi notifikasi) {
    final tipeColor = notifikasi.tipe == 'harian'
        ? AppColors.error
        : notifikasi.tipe == 'mingguan'
            ? AppColors.primary
            : AppColors.success;

    final tipeIcon = notifikasi.tipe == 'harian'
        ? Icons.today
        : notifikasi.tipe == 'mingguan'
            ? Icons.view_week
            : Icons.calendar_month;

    final tipeLabel = notifikasi.tipe == 'harian'
        ? 'Harian'
        : notifikasi.tipe == 'mingguan'
            ? 'Mingguan'
            : 'Bulanan';

    return GestureDetector(
      onTap: () {
        if (!notifikasi.isRead) {
          context.read<NotifikasiProvider>().tandaiDibaca(notifikasi.id!);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: notifikasi.isRead
              ? null
              : Border.all(color: tipeColor.withValues(alpha: 0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: tipeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(tipeIcon, color: tipeColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notifikasi.judul,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyContext(context).copyWith(
                            fontWeight: FontWeight.w600,
                            color: notifikasi.isRead ? null : tipeColor,
                          ),
                        ),
                      ),
                      if (!notifikasi.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: tipeColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notifikasi.pesan,
                    style: AppTextStyles.captionContext(context),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: tipeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tipeLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: tipeColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatWaktu(notifikasi.createdAt),
                        style: AppTextStyles.captionContext(context).copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              color: AppColors.grey,
              onPressed: () {
                context.read<NotifikasiProvider>().hapus(notifikasi.id!);
              },
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  String _formatWaktu(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }

  void _tandaiSemuaDibaca() {
    context.read<NotifikasiProvider>().tandaiSemuaDibaca();
  }
}
