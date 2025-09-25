import 'package:flutter/material.dart';

class EditionCard extends StatelessWidget {
  final String title;
  final String? author;
  final String? publishedDate;
  final String? coverUrl;

  const EditionCard({
    super.key,
    required this.title,
    this.author,
    this.publishedDate,
    this.coverUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: coverUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  coverUrl!,
                  width: 50,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.book),
                ),
              )
            : const Icon(Icons.book, size: 40),
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (author != null) Text("By $author"),
            if (publishedDate != null) Text("Published: $publishedDate"),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Navigate to edition detail screen
        },
      ),
    );
  }
}
