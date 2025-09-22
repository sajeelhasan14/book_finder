import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_finder/providers/work_detail_provider.dart';
import 'package:book_finder/screens/editions/editions_screen.dart';

class WorkDetailScreen extends StatelessWidget {
  final String workId;

  const WorkDetailScreen({super.key, required this.workId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkDetailProvider()..loadWork(workId),
      child: Consumer<WorkDetailProvider>(
        builder: (context, prov, _) {
          if (prov.state == WorkDetailState.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (prov.state == WorkDetailState.error) {
            return Scaffold(
              body: Center(child: Text("Error: ${prov.errorMessage}")),
            );
          } else if (prov.state == WorkDetailState.data && prov.work != null) {
            final work = prov.work!;
            return Scaffold(
              appBar: AppBar(title: Text(work.title ?? "Book Details")),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (work.title != null)
                      Text(
                        work.title!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (work.description != null)
                      Text(work.description!),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditionsScreen(
                              workId: work.key!.replaceFirst('/works/', ''),
                              title: work.title ?? "Untitled",
                            ),
                          ),
                        );
                      },
                      child: const Text("View Editions"),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: Text("No details found")),
            );
          }
        },
      ),
    );
  }
}
