import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_finder/providers/book_provider.dart';
import 'package:book_finder/widgets/book_card.dart';
import 'package:book_finder/screens/work_detail/work_detail_screen.dart';

class MoreBooksScreen extends StatelessWidget {
  final String type; // 'trending' or 'recent'

  const MoreBooksScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          type == 'trending' ? 'Trending Books' : 'Recently Added',
        ),
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProv, _) {
          final books =
              type == 'trending' ? bookProv.trending : bookProv.trending;
          final isLoading = type == 'trending'
              ? bookProv.isLoadingTrending
              : bookProv.isLoadingTrending;
          final error = type == 'trending'
              ? bookProv.errorTrending
              : bookProv.errorTrending;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: $error'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (type == 'trending') {
                        bookProv.fetchTrending(limit: 20);
                      } else {
                        bookProv.fetchTrending
                        (limit: 20);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (books.isEmpty) {
            return const Center(child: Text('No books found.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (type == 'trending') {
                await bookProv.fetchTrending(limit: 20);
              } else {
                await bookProv.fetchTrending(limit: 20);
              }
            },
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return BookCard(
                  work: book,
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => WorkDetailScreen(workId: book.workId),
                    //   ),
                    // );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
