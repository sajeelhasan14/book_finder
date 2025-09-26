import 'package:book_finder/screens/editions/editions_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_finder/providers/search_provider.dart';
import 'package:book_finder/widgets/book_card.dart';
import 'package:book_finder/widgets/book_card_skeleton.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<SearchProvider>();
    _searchController = TextEditingController(text: widget.initialQuery ?? "");
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      Future.microtask(() {
        context.read<SearchProvider>().updateQuery(widget.initialQuery!);
      });
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          provider.hasMore &&
          !provider.isLoading) {
        provider.fetchBooks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: [
                // 🔍 Search bar
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.white,
                  child: TextField(
                    onChanged: provider.updateQuery,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: provider.query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => provider.updateQuery(''),
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // 🔖 Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: FilterType.values.map((f) {
                      final label =
                          f.name[0].toUpperCase() + f.name.substring(1);
                      final isSelected = provider.filter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          selected: isSelected,
                          selectedColor: Colors.deepPurple,
                          backgroundColor: Colors.grey[200],
                          label: Text(
                            label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          onSelected: (_) => provider.updateFilter(f),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // 📚 Results
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (provider.error != null) {
                        return ErrorStateWidget(
                          message: provider.error!,
                          onRetry: provider.retry,
                        );
                      }
                      if (!provider.isLoading &&
                          provider.results.isEmpty &&
                          provider.query.isNotEmpty) {
                        return EmptyStateWidget(
                          message: 'No results found for "${provider.query}".',
                        );
                      }
                      if (provider.results.isEmpty && provider.query.isEmpty) {
                        return const EmptyStateWidget(
                          message: 'Start typing to find a book.',
                        );
                      }

                      return GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.65,
                            ),
                        itemCount:
                            provider.results.length +
                            (provider.isLoading ? 6 : 0),
                        itemBuilder: (context, index) {
                          if (index < provider.results.length) {
                            final book = provider.results[index];
                            return BookCard(work: book);
                          } else {
                            return const BookCardSkeleton();
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
