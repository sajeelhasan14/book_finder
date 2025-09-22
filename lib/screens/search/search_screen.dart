// lib/screens/search/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_finder/providers/search_provider.dart';
import 'package:book_finder/widgets/book_card.dart';
import 'package:book_finder/screens/work_detail/work_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<SearchProvider>(context, listen: false);
      if ((widget.initialQuery ?? '').isNotEmpty) {
        prov.search(widget.initialQuery!, reset: true);
      }
    });
  }

  void _onScroll() {
    final prov = Provider.of<SearchProvider>(context, listen: false);
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 200) prov.loadMore();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _doSearch() {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    Provider.of<SearchProvider>(context, listen: false).search(q, reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          onSubmitted: (_) => _doSearch(),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search...',
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _doSearch),
        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, prov, _) {
          if (prov.state == DataState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (prov.state == DataState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${prov.errorMessage}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () =>
                        prov.search(_controller.text.trim(), reset: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (prov.state == DataState.empty) {
            return const Center(child: Text('No results found'));
          }
          if (prov.state == DataState.data || prov.state == DataState.idle) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: prov.works.length + (prov.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < prov.works.length) {
                  final w = prov.works[index];
                  return BookCard(
  work: w,
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => WorkDetailScreen(workId: w.key ?? ''),
    ),
  ),
);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            );
          }
          return const Center(child: Text('Type a query to start'));
        },
      ),
    );
  }
}
