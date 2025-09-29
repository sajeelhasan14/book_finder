// lib/screens/author/author_detail_screen.dart
import 'package:book_finder/core/constant.dart';
import 'package:book_finder/services/open_library_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:book_finder/providers/author_provider.dart';

class AuthorDetailScreen extends StatefulWidget {
  final String authorId;

  const AuthorDetailScreen({super.key, required this.authorId});

  @override
  State<AuthorDetailScreen> createState() => _AuthorDetailScreenState();
}

class _AuthorDetailScreenState extends State<AuthorDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AuthorProvider>(
        context,
        listen: false,
      ).loadAuthor(widget.authorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthorProvider>(context);
    final authorData = provider.author;

    if (provider.state == AuthorState.loading) {
      return const Scaffold(
        body: Center(
          child: SpinKitThreeBounce(color: Colors.deepPurple, size: 30),
        ),
      );
    }

    if (provider.state == AuthorState.error) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Author Details",
            style: TextStyle(
              fontFamily: "Cinzel",
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ),
        body: Center(
          child: Text(provider.errorMessage ?? "Something went wrong"),
        ),
      );
    }

    if (authorData == null) {
      return const Scaffold(
        body: Center(child: Text("No author data available")),
      );
    }

    final photoUrl =
        (authorData.photos != null && authorData.photos!.isNotEmpty)
        ? OpenLibraryApi.getAuthorPhoto(
            authorData.photos!.first.toString(),
            size: ApiConstants.coverLarge,
          )
        : null;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Author Details",
          style: TextStyle(
            fontFamily: "Cinzel",
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 300,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: photoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.person, size: 50),
                          ),
                        )
                      : const Icon(Icons.person, size: 50),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  authorData.name ?? "Unknown Author",
                  style: const TextStyle(
                    fontFamily: "Cinzel",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  "Birth Date: ${authorData.birthDate ?? "Not updated on the server"}",
                  style: TextStyle(
                    fontFamily: "Cinzel",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "DESCRIPTION",
                style: TextStyle(
                  fontFamily: "Cinzel",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF444444),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                authorData.bio?.value ??
                    "Your writing reflects a remarkable blend of creativity, clarity, and depth. The way you organize ideas shows not only strong command of language but also an ability to connect with readers on an emotional level. Each line carries thoughtfulness, and the flow of your expression demonstrates both skill and dedication to the craft. It’s evident that you put genuine effort into shaping your words, and that passion makes your work engaging and impactful. Writers like you remind us of the power of language to inspire, inform, and move people.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
