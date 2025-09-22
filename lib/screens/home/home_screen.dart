// lib/screens/home/home_screen.dart
import 'package:book_finder/providers/favorite_provider.dart';
import 'package:book_finder/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_finder/providers/auth_provider.dart';


class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController ctrl = TextEditingController();
    final auth = Provider.of<AuthProvider>(context);
    final favProv = Provider.of<FavoritesProvider>(context);

    final subjects = [
      'fantasy',
      'science_fiction',
      'history',
      'romance',
      'mystery_and_detective_stories',
      'children',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Finder'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (v) {
                      if (v.trim().isEmpty) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchScreen(initialQuery: v.trim()),
                        ),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Search books, authors, ISBN...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          if (ctrl.text.trim().isEmpty) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SearchScreen(initialQuery: ctrl.text.trim()),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subjects.length,
                itemBuilder: (context, idx) {
                  final s = subjects[idx];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SearchScreen(initialQuery: 'subject:$s'),
                      ),
                    ),
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.replaceAll('_', ' ').toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Text(
                            'Tap to browse',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: auth.isSignedIn
                  ? _buildFavorites(favProv)
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Sign in to see favorites'),
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/signin'),
                            child: const Text('Sign in'),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavorites(FavoritesProvider prov) {
    if (prov.favorites.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }
    return ListView.builder(
      itemCount: prov.favorites.length,
      itemBuilder: (ctx, idx) {
        final f = prov.favorites[idx];
        // f must contain title, authors, coverUrl, firstPublishYear
        final title = f['title'] ?? 'Untitled';
        final authors =
            (f['authors'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .join(', ') ??
            'Unknown';
        return ListTile(
          title: Text(title.toString()),
          subtitle: Text(authors),
          leading: f['coverUrl'] != null
              ? Image.network(f['coverUrl'], width: 50, fit: BoxFit.cover)
              : const Icon(Icons.book),
        );
      },
    );
  }
}
