import 'package:book_finder/core/constant.dart';
import 'package:book_finder/providers/subject_provider.dart';
import 'package:book_finder/screens/work_detail/subject_work_detail.dart';


import 'package:book_finder/services/open_library_api.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SubjectScreen extends StatefulWidget {
  final String subject;
  const SubjectScreen({required this.subject, super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<SubjectProvider>(
        context,
        listen: false,
      ).loadSubject(widget.subject),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubjectProvider>(context);
    final subjectData = provider.works;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.subject,
          style: TextStyle(
            fontFamily: "Cinzel",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: provider.isLoading
          ? const Center(
              child: SpinKitThreeBounce(color: Colors.deepPurple, size: 30),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: subjectData.length,
              itemBuilder: (context, index) {
                final work = subjectData[index];
                final coverUrl = work.coverId != null
                    ? OpenLibraryApi.getCoverUrl(
                        work.coverId!,
                        size: ApiConstants.coverLarge,
                      )
                    : null;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubjectWorkDetailScreen(work: work),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 0, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 📘 Book cover
                        Container(
                          height: 180,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: coverUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    coverUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.book, size: 50),
                                  ),
                                )
                              : const Icon(Icons.book, size: 50),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: SizedBox(
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  work.title ?? "No Title",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: "Cinzel",
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  (work.authors != null &&
                                          work.authors!.isNotEmpty)
                                      ? work.authors!.first.name ?? "Unknown"
                                      : "Unknown",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
