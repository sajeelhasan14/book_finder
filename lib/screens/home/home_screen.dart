import 'package:book_finder/providers/favorite_provider.dart';
import 'package:book_finder/providers/auth_provider.dart';
import 'package:book_finder/providers/subject_provider.dart';
import 'package:book_finder/screens/search/search_screen.dart';
import 'package:book_finder/widgets/subject_chip.dart';
import 'package:book_finder/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final favProv = Provider.of<FavoritesProvider>(context);
    final subjectProv = Provider.of<SubjectProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Finder'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            /// 🎯 Subject Chips
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: subjects.map((s) {
                  return SubjectChip(
                    label: s.replaceAll('_', ' ').toUpperCase(),
                    selected: subjectProv.selectedSubject == s,
                    onTap: () {
                      subjectProv.selectSubject(s);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SearchScreen(initialQuery: 'subject:$s'),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            /// 🔥 Trending header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Trending",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SearchScreen(initialQuery: 'trending'),
                      ),
                    );
                  },
                  child: const Text("More >"),
                ),
              ],
            ),

            /// 🔥 Trending Books List
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Replace with trending.length
                itemBuilder: (context, index) {
                  return BookCard(
                    title: "Trending Book ${index + 1}",
                    author: "Author $index",
                    coverUrl: null,
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            /// 🆕 Recently Added header
            const Text(
              "Recently Added",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// 🆕 Recently Added Books List
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Replace with recent.length
                itemBuilder: (context, index) {
                  return BookCard(
                    title: "Recent Book ${index + 1}",
                    author: "Author $index",
                    coverUrl: null,
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            /// ❤️ Favorites or Sign-in prompt
            auth.isSignedIn
                ? SizedBox(
                    height: 250,
                    child: _buildFavorites(favProv),
                  )
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
          ],
        ),
      ),

      /// 📌 Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              break; // Already Home
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(initialQuery: ""),
                ),
              );
              break;
            case 2:
              // Favorites screen
              break;
            case 3:
              // Settings screen
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  Widget _buildFavorites(FavoritesProvider prov) {
    if (prov.favorites.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: prov.favorites.length,
      itemBuilder: (ctx, idx) {
        final f = prov.favorites[idx];
        final title = f['title'] ?? 'Untitled';
        final authors =
            (f['authors'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .join(', ') ??
            'Unknown';
        return BookCard(
          title: title.toString(),
          author: authors,
          coverUrl: f['coverUrl'],
        );
      },
    );
  }
}
