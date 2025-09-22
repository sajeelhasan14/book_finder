import 'package:flutter/material.dart';
import 'package:book_finder/models/book_work_model.dart';
import 'package:book_finder/models/book_work.dart';

class BookCard extends StatelessWidget {
  final BookWork? work; // From search results
  final BookWorkModel? workModel; // From detailed API
  final String? title; // Manual fallback
  final String? author; // Manual fallback
  final String? coverUrl; // Manual fallback
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    this.work,
    this.workModel,
    this.title,
    this.author,
    this.coverUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle =
        workModel?.title ?? work?.title ?? title ?? "Untitled";

    final displayAuthor = workModel?.authors
            ?.map((a) => a.author?.key ?? "")
            .where((s) => s.isNotEmpty)
            .join(', ') ??
        (work?.authors.join(", ") ?? author ?? "Unknown");

    final displayCover = (workModel?.covers != null &&
            workModel!.covers!.isNotEmpty)
        ? "https://covers.openlibrary.org/b/id/${workModel!.covers!.first}-M.jpg"
        : (work?.coverId != null
            ? "https://covers.openlibrary.org/b/id/${work!.coverId}-M.jpg"
            : coverUrl);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            displayCover != null
                ? ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      displayCover,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: const Icon(
                      Icons.book,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                displayTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                displayAuthor.isNotEmpty ? displayAuthor : "Unknown",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
