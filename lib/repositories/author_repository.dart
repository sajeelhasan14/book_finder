import 'package:book_finder/models/book_work_model.dart';
import 'package:book_finder/services/open_library_api.dart';
import 'package:book_finder/models/author.dart';


class AuthorRepository {
  // Get author details by ID
  static Future<AuthorModel> getAuthor(String authorId) async {
    final  resp = await OpenLibraryApi.getAuthor(authorId);
    final Map<String, dynamic> data = Map<String, dynamic>.from(resp?.data as Map);
    return AuthorModel.fromJson(data);
  }

  // Get works written by a specific author
  static Future<List<BookWorkModel>> getAuthorWorks(String authorId, {int limit = 50, int offset = 0}) async {
    final  resp = await OpenLibraryApi.getAuthorWorks(authorId, limit: limit, offset: offset);
    final Map<String, dynamic> data = Map<String, dynamic>.from(resp?.data as Map);
    final entries = (data['entries'] as List<dynamic>?) ?? [];

    // Map entries into BookWork (best-effort, since API format can vary)
    return entries.map((e) {
      final m = Map<String,dynamic>.from(e as Map);
      return BookWorkModel(
        key: m['key'] as String? ?? '',
        title: m['title'] as String? ?? '',
        authors: [], // authors info may not be included here
        
      );
    }).toList();
  }
}
