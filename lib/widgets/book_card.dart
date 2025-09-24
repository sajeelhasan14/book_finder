// lib/widgets/book_card.dart
import 'package:book_finder/screens/work_detail/work_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:book_finder/models/book_work.dart';
import 'package:book_finder/services/open_library_api.dart';
import 'package:book_finder/core/constant.dart';

class BookCard extends StatelessWidget {
  final BookWork work;
  final double width;
  final bool isHorizontal;

  const BookCard({
    super.key,
    required this.work,
    this.width = 150,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    final coverUrl = work.coverId != null
        ? OpenLibraryApi.getCoverUrl(
            work.coverId!,
            size: ApiConstants.coverLarge,
          )
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => WorkDetailScreen(work: work)),
        );
      },
      child: Container(
        width: width,
        margin: EdgeInsets.only(
          right: isHorizontal ? 14 : 0,
          bottom: isHorizontal ? 0 : 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📘 Book cover
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: coverUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.book, size: 50),
                      ),
                    )
                  : const Icon(Icons.book, size: 50),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    work.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Cinzel",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    work.authors.isNotEmpty ? work.authors.first : "Unknown",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
