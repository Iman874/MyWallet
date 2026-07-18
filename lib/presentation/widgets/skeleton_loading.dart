import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoading({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SkeletonLoading(width: 44, height: 44, borderRadius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoading(width: 100, height: 14),
                const SizedBox(height: 8),
                SkeletonLoading(width: 60, height: 12, borderRadius: 4),
              ],
            ),
          ),
          const SkeletonLoading(width: 80, height: 16),
        ],
      ),
    );
  }
}

class SkeletonDashboard extends StatelessWidget {
  const SkeletonDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saldo card skeleton
          Shimmer.fromColors(
            baseColor: Colors.blue[300]!,
            highlightColor: Colors.blue[100]!,
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[600]!],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Ringkasan skeleton
          const SkeletonLoading(width: 120, height: 18),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildSummarySkeleton()),
              const SizedBox(width: 12),
              Expanded(child: _buildSummarySkeleton()),
            ],
          ),
          const SizedBox(height: 24),
          // Transaksi terbaru skeleton
          const SkeletonLoading(width: 140, height: 18),
          const SizedBox(height: 16),
          ...List.generate(3, (_) => const SkeletonCard()),
        ],
      ),
    );
  }

  Widget _buildSummarySkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SkeletonLoading(width: 32, height: 32, borderRadius: 8),
              const SizedBox(width: 8),
              SkeletonLoading(width: 70, height: 12),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonLoading(width: 90, height: 16),
        ],
      ),
    );
  }
}
