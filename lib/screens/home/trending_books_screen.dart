import 'package:book_finder/core/constant.dart';
import 'package:book_finder/providers/book_provider.dart';

import 'package:book_finder/screens/work_detail/work_detail_screen.dart';
import 'package:book_finder/services/open_library_api.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class TrendingBookScreen extends StatefulWidget {
  static const routeName = '/';
  const TrendingBookScreen({super.key});

  @override
  State<TrendingBookScreen> createState() => _TrendingBookScreenState();
}

class _TrendingBookScreenState extends State<TrendingBookScreen> {
  final TextEditingController ctrl = TextEditingController();

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Fetch trending books
    Future.microtask(
      () => Provider.of<BookProvider>(
        context,
        listen: false,
      ).fetchTrending(limit: 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final trending = bookProvider.trending;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Trending Books",
          style: TextStyle(
            fontFamily: "Cinzel",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: bookProvider.isLoadingTrending
          ? const Center(
              child: SpinKitThreeBounce(color: Colors.deepPurple, size: 30),
            )
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.60,
              ),
              itemCount: trending.length,
              itemBuilder: (context, index) {
                final work = trending[index];
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
                      MaterialPageRoute(
                        builder: (_) => WorkDetailScreen(work: work),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 0, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 📘 Book cover
                        Container(
                          height: 200,
                          width: 170,
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
                        const SizedBox(height: 5),
                        Expanded(
                          child: SizedBox(
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  work.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: "Cinzel",
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  work.authors.isNotEmpty
                                      ? work.authors.first
                                      : "Unknown",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
