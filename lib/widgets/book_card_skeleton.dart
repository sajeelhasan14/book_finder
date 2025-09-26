import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookCardSkeleton extends StatelessWidget {
  const BookCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📘 Cover placeholder
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // 📖 Title placeholder
            Container(
              height: 14,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.grey[300],
            ),
            const SizedBox(height: 6),

            // ✍️ Author placeholder
            Container(
              height: 12,
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
