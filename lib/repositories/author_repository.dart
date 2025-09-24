// lib/repositories/author_repository.dart
import 'package:dio/dio.dart';
import 'package:book_finder/services/open_library_api.dart';
import 'package:book_finder/models/author.dart';
import 'package:book_finder/models/book_work.dart';

class AuthorRepository {
  // 🔎 Fetch author details by ID and map to AuthorModel
  static Future<AuthorModel> getAuthor(String authorId) async {
    final Response resp = await OpenLibraryApi.getAuthor(authorId);
    final Map<String, dynamic> data = Map<String, dynamic>.from(resp.data as Map);
    return AuthorModel.fromJson(data);
  }

  // 📚 Fetch works by an author and map to a list of BookWork models
  static Future<List<BookWork>> getAuthorWorks(String authorId, {int limit = 50, int offset = 0}) async {
    final Response resp = await OpenLibraryApi.getAuthorWorks(authorId, limit: limit, offset: offset);
    final Map<String, dynamic> data = Map<String, dynamic>.from(resp.data as Map);

    // The response contains 'entries' → list of works
    final entries = (data['entries'] as List<dynamic>?) ?? [];

    // Convert each entry to BookWork (best-effort mapping)
    return entries.map((e) {
      final m = Map<String, dynamic>.from(e as Map);

      return BookWork(
        key: m['key'] as String? ?? '',
        title: m['title'] as String? ?? '',
        authors: [], // API doesn’t always return authors here
        firstPublishYear: (m['first_publish_year'] is num)
            ? (m['first_publish_year'] as num).toInt()
            : null,
        coverId: (m['cover_id'] is num) ? (m['cover_id'] as num).toInt() : null,
      );
    }).toList();
  }
}
