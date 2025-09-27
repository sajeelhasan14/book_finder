import 'package:book_finder/providers/book_provider.dart';
import 'package:book_finder/providers/favorite_provider.dart';
import 'package:book_finder/screens/auth/signup_screen.dart';
import 'package:book_finder/widgets/popular_subject_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    'Fantasy',
    'Science Fiction',
    'History',
    'Romance',
    'Mystery',
    'Children',
  ];

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<BookProvider>(
        context,
        listen: false,
      ).fetchTrending(limit: 10),
    );

    Future.microtask(() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final favProvider = Provider.of<FavoriteProvider>(context, listen: false);

      if (authProvider.isSignedIn) {
        favProvider.setUser(authProvider.user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final favProv = Provider.of<FavoriteProvider>(context);
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          'Book Finder',
          style: TextStyle(
            fontFamily: "Cinzel",
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 Subtitle
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: const Text(
                "Discover your next great read.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            // 🔍 Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: ctrl,
                textInputAction: TextInputAction.search,
                onSubmitted: (query) {
                  if (query.trim().isEmpty) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchScreen(initialQuery: query.trim()),
                    ),
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search for titles, authors, or ISBNs...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 🎯 Popular Subjects
            const Text(
              "Popular Subjects",
              style: TextStyle(
                fontFamily: "Cinzel",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF444444),
              ),
            ),
            const SizedBox(height: 12),
            SubjectChip(labels: subjects),
            const SizedBox(height: 28),

            // 📌 Trending Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Trending",
                  style: TextStyle(
                    fontFamily: "Cinzel",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF444444),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "More",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 250,
              child: bookProvider.isLoadingTrending
                  ? const Center(
                      child: SpinKitThreeBounce(
                        color: Colors.deepPurple,
                        size: 30,
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bookProvider.trending.length,
                      itemBuilder: (context, index) {
                        final work = bookProvider.trending[index];

                        return BookCard(work: work);
                      },
                    ),
            ),
            const SizedBox(height: 28),

            // ❤️ Favorites
            const Text(
              "Your Favorites",
              style: TextStyle(
                fontFamily: "Cinzel",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF444444),
              ),
            ),
            const SizedBox(height: 12),

            auth.isSignedIn
                ? (favProv.favorites.isNotEmpty
                      ? SizedBox(
                          height: 250, // give some height for BookCard
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: favProv.favorites.length,
                            itemBuilder: (ctx, idx) {
                              final f = favProv.favorites[idx];
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
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: BookCard(work: work),
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Your favorites list is empty.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ))
                : Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Sign in to see your favorites and sync them across devices.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF673AB7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            ),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
