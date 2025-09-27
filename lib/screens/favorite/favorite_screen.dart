import 'package:book_finder/models/book_work.dart';
import 'package:book_finder/providers/favorite_provider.dart';
import 'package:book_finder/screens/work_detail/work_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: favProvider.favorites.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: favProvider.favorites.length,
              itemBuilder: (context, index) {
                final f = favProvider.favorites[index];

                final work = BookWork(
                  key: f['key'] ?? '',
                  title: f['title'] ?? 'Untitled',
                  authors:
                      (f['authors'] as List<dynamic>?)
                          ?.map((e) => e.toString())
                          .toList() ??
                      [],
                  coverId: f['coverId'],
                  firstPublishYear: f['firstPublishYear'],
                );

                return ListTile(
                  leading: work.coverId != null
                      ? Image.network(
                          'https://covers.openlibrary.org/b/id/${work.coverId}-M.jpg',
                          width: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.book),
                  title: Text(work.title),
                  subtitle: Text(work.authors.join(", ")),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      favProvider.toggleFavorite(
                        key: work.key,
                        title: work.title,
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkDetailScreen(work: work),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
