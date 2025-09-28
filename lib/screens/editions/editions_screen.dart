import 'package:book_finder/models/book_work.dart';
import 'package:book_finder/models/subject_model.dart';
import 'package:book_finder/screens/work_detail/work_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_finder/providers/editions_provider.dart';
import 'package:book_finder/services/open_library_api.dart';

class EditionsScreen extends StatefulWidget {
  
final BookWork work;
  final String workId;
  final String title;

  const EditionsScreen({super.key, required this.workId, required this.title,required this.work});

  @override
  State<EditionsScreen> createState() => _EditionsScreenState();
}

class _EditionsScreenState extends State<EditionsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<EditionsProvider>(
        context,
        listen: false,
      ).loadEditions(widget.workId),
    );

    _scrollController.addListener(() {
      final provider = Provider.of<EditionsProvider>(context, listen: false);

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoadingMore &&
          provider.state == EditionsState.data) {
        provider.loadMore(widget.workId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditionsProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Book Editions",
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Cinzel",
                fontWeight: FontWeight.bold,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis, // still trims if > 2 lines
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Builder(
              builder: (context) {
                switch (provider.state) {
                  case EditionsState.loading:
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (_, i) => const SkeletonCard(),
                    );

                  case EditionsState.error:
                    return ErrorStateWidget(
                      message: provider.errorMessage ?? "Something went wrong",
                      onRetry: () =>
                          provider.loadEditions(widget.workId, reset: true),
                    );

                  case EditionsState.empty:
                    return const EmptyStateWidget(
                      message: "No editions found for this book.",
                    );

                  case EditionsState.data:
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          provider.editions.length +
                          (provider.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < provider.editions.length) {
                          final ed = provider.editions[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder:(context)=>WorkDetailScreen(work: widget.work)));
                              },
                              child: EditionCard(
                                title: ed.title ?? "Untitled",
                                publisher:
                                    (ed.publishers != null &&
                                        ed.publishers!.isNotEmpty)
                                    ? ed.publishers!.first
                                    : "Unknown Publisher",
                                year: ed.publishDate ?? "Unknown",
                                language:
                                    (ed.languages != null &&
                                        ed.languages!.isNotEmpty)
                                    ? ed.languages!.first
                                    : null,
                                coverId: ed.coverId,
                              ),
                            ),
                          );
                        } else {
                          // Loading more indicator
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    );

                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class EditionCard extends StatelessWidget {
  final String title;
  final String publisher;
  final String year;
  final String? language;
  final int? coverId;

  const EditionCard({
    super.key,
    required this.title,
    required this.publisher,
    required this.year,
    this.language,
    this.coverId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(1, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          Container(
            width: 70,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[300],
            ),
            clipBehavior: Clip.antiAlias,
            child: coverId != null
                ? Image.network(
                    OpenLibraryApi.getCoverUrl(coverId!, size: "S"),
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.book, size: 40, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "by $publisher",
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  year,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                if (language != null) ...[
                  const SizedBox(height: 6),
                  Chip(
                    label: Text(
                      language!.replaceAll(RegExp(r'^/languages/'), ''),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: Colors.deepPurple[100],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 120, color: Colors.grey[300]),
                const SizedBox(height: 8),
                Container(height: 14, width: 80, color: Colors.grey[300]),
                const SizedBox(height: 8),
                Container(height: 14, width: 50, color: Colors.grey[300]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;

  const EmptyStateWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
