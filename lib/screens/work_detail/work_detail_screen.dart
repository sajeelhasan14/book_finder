import 'package:book_finder/core/constant.dart';
import 'package:book_finder/models/book_work.dart';
import 'package:book_finder/models/book_work_model.dart';
import 'package:book_finder/providers/book_provider.dart';
import 'package:book_finder/services/open_library_api.dart';
import 'package:book_finder/widgets/chips.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkDetailScreen extends StatefulWidget {
  final BookWork work;

  const WorkDetailScreen({required this.work, super.key});

  @override
  State<WorkDetailScreen> createState() => _WorkDetailScreenState();
}

class _WorkDetailScreenState extends State<WorkDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<BookProvider>(
        context,
        listen: false,
      ).fetchTrending(limit: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coverUrl = widget.work.coverId != null
        ? OpenLibraryApi.getCoverUrl(
            widget.work.coverId!,
            size: ApiConstants.coverLarge,
          )
        : null;
    final subjects = Provider.of<BookProvider>(
      context,
    ).detailData.first.subjects;
    print(subjects);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min, // Important: shrink the column
          children: [
            Text(
              widget.work.title,
              style: TextStyle(
                fontFamily: "Cinzel",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "by ${widget.work.authors[0]}",
              style: TextStyle(
                fontFamily: "Cinzel",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 250,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
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
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChipWidget(text: widget.work.authors[0]),
                SizedBox(width: 20),
                ChipWidget(
                  text: widget.work.firstPublishYear.toString(),
                  purple: false,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "SUBJECTS",
              style: TextStyle(
                fontFamily: "Cinzel",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF444444),
              ),
            ),
            ChipWidget(text: subjects![0]),
          ],
        ),
      ),
    );
  }
}
