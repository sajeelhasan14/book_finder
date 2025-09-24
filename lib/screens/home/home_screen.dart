// lib/screens/home/home_screen.dart
import 'package:book_finder/providers/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_finder/screens/search/search_screen.dart';
import 'package:book_finder/providers/auth_provider.dart';

import 'package:book_finder/widgets/book_card.dart';
import 'package:book_finder/models/book_work.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController ctrl = TextEditingController();

  final subjects = const [
    'fantasy',
    'science_fiction',
    'history',
    'romance',
    'mystery_and_detective_stories',
    'children',
  ];

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final favProv = Provider.of<FavoritesProvider>(context);

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
            /// 🔍 Search bar
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
                              builder: (_) => SearchScreen(
                                initialQuery: ctrl.text.trim(),
                              ),
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

            /// 🎯 Subject chips
            SizedBox(
              height: 50,
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
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.deepPurple.shade100),
                      ),
                      child: Text(
                        s.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),

            /// ❤️ Favorites or sign-in prompt
            Expanded(
              child: auth.isSignedIn
                  ? _buildFavorites(favProv)
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Sign in to see favorites'),
                          const SizedBox(height: 8),
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

        // Safely build BookWork from favorite map
        final work = BookWork(
          key: f['key'] ?? '',
          title: f['title'] ?? 'Untitled',
          authors: (f['authors'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
          coverId: f['coverId'],
          firstPublishYear: f['firstPublishYear'],
        );

        return BookCard(work: work);
      },
    );
  }
}
