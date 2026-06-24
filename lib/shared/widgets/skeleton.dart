import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height = 16, this.radius = 8});
  final double? width;
  final double  height;
  final double  radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor:  isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Container(
        width:  width,
        height: height,
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Kart satırı — liste ekranlarında kullanılır
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          SkeletonBox(width: 48, height: 48, radius: 12),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 140, height: 14),
                const SizedBox(height: 8),
                SkeletonBox(width: 90, height: 11),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SkeletonBox(width: 70, height: 14),
              const SizedBox(height: 8),
              SkeletonBox(width: 50, height: 11),
            ],
          ),
        ],
      ),
    );
  }
}

/// N adet SkeletonListTile — tek satırla kullanım
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 6});
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (_, __) => const SkeletonListTile(),
    );
  }
}
