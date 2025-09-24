// lib/widgets/book_card.dart
import 'package:book_finder/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:book_finder/models/book_work.dart';
import 'package:book_finder/services/open_library_api.dart';


class BookCard extends StatelessWidget {
  final BookWork work;          // The book/work data to display
  final VoidCallback? onTap;    // Optional callback when the card is tapped

  const BookCard({super.key, required this.work, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Build the cover image URL if a coverId exists, otherwise null
    final coverUrl = work.coverId != null
        ? OpenLibraryApi.getCoverUrl(work.coverId!, size: ApiConstants.coverMedium)
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: InkWell(
        onTap: onTap, // Handle tap (e.g., navigate to details screen)
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              // Left side: cover image (or placeholder)
              Container(
                width: 70,
                height: 100,
                color: Colors.grey.shade200, // fallback background
                child: coverUrl != null
                    ? Image.network(
                        coverUrl,
                        fit: BoxFit.cover,
                        // If image fails to load → show book icon
                        errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 40),
                      )
                    : const Icon(Icons.book, size: 40), // Default icon if no coverId
              ),
              const SizedBox(width: 12),

              // Right side: book details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Book title
                      Text(
                        work.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Author(s) or "Unknown"
                      Text(
                        work.authors.isNotEmpty ? work.authors.join(', ') : 'Unknown',
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),

                      // First publish year if available
                      if (work.firstPublishYear != null)
                        Text(
                          'First: ${work.firstPublishYear}',
                          style: const TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
