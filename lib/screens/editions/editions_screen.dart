import 'package:flutter/material.dart';
import 'package:book_finder/services/open_library_api.dart';

class EditionsScreen extends StatefulWidget {
  final String workId;
  final String title;

  const EditionsScreen({
    super.key,
    required this.workId,
    required this.title,
  });

  @override
  State<EditionsScreen> createState() => _EditionsScreenState();
}

class _EditionsScreenState extends State<EditionsScreen> {
  List<dynamic> editions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadEditions();
  }

  Future<void> loadEditions() async {
    try {
      final resp = await OpenLibraryApi.getEditions(widget.workId);
      final data = resp.data as Map<String, dynamic>;
      setState(() {
        editions = data['entries'] ?? [];
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading editions: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editions of ${widget.title}")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : editions.isEmpty
              ? const Center(child: Text("No editions found"))
              : ListView.builder(
                  itemCount: editions.length,
                  itemBuilder: (context, index) {
                    final ed = editions[index];
                    return ListTile(
                      title: Text(ed['title'] ?? "Untitled"),
                      subtitle: Text(
                        "Publish date: ${ed['publish_date'] ?? 'Unknown'}",
                      ),
                    );
                  },
                ),
    );
  }
}
