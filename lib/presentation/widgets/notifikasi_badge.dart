import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notifikasi_provider.dart';
import '../screens/notifikasi_screen.dart';
import '../../core/theme/app_colors.dart';

class NotifikasiBadge extends StatelessWidget {
  const NotifikasiBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotifikasiProvider>(
      builder: (context, provider, child) {
        final jumlah = provider.jumlahBelumDibaca;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotifikasiScreen()),
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  size: 22,
                ),
              ),
              if (jumlah > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      jumlah > 99 ? '99+' : '$jumlah',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
