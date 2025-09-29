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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Favorites",
          style: TextStyle(
            fontFamily: "Cinzel",
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: favProvider.favorites.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "You haven't added any books to your favorites yet.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: favProvider.favorites.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final f = favProvider.favorites[index];

                  final work = BookWork(
                    key: f['key'] ?? '',
                    title: f['title'] ?? 'Untitled',
                    authors:
                        (f['authors'] as List<dynamic>?)?.map((e) {
                          if (e is Map && e.containsKey('name')) {
                            return e['name'].toString();
                          }
                          return e.toString();
                        }).toList() ??
                        [],
                    coverId: f['coverId'],
                    firstPublishYear: f['firstPublishYear'],
                  );

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: work.coverId != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://covers.openlibrary.org/b/id/${work.coverId}-M.jpg',
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.book),
                      title: Text(
                        work.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        work.authors.isNotEmpty
                            ? work.authors.first.toString()
                            : "Unknown Author",
                      ),

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
                        print(Text(work.authors[0]));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkDetailScreen(work: work),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
