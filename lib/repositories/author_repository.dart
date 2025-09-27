// lib/repositories/author_repository.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:book_finder/services/open_library_api.dart';
import 'package:book_finder/models/author.dart';
import 'package:book_finder/models/book_work.dart';

class AuthorRepository {
  // 🔎 Fetch author details by ID and map to AuthorModel
  static Future<AuthorModel> getAuthor(String authorId) async {
    final Response resp = await OpenLibraryApi.getAuthor(authorId);
    

    // Ensure resp.data is always a Map
    final Map<String, dynamic> data = (resp.data is Map)
        ? Map<String, dynamic>.from(resp.data as Map)
        : json.decode(resp.data.toString()) as Map<String, dynamic>;

    return AuthorModel.fromJson(data);
  }

  // 📚 Fetch works by an author and map to a list of BookWork models
  static Future<List<BookWork>> getAuthorWorks(
    String authorId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final Response resp = await OpenLibraryApi.getAuthorWorks(
      authorId,
      limit: limit,
      offset: offset,
    );

    // Debug print → check what OpenLibrary returns

    // Safely convert resp.data to Map
    final Map<String, dynamic> data = (resp.data is Map)
        ? Map<String, dynamic>.from(resp.data as Map)
        : json.decode(resp.data.toString()) as Map<String, dynamic>;

    // Extract entries
    final entries = (data['entries'] as List<dynamic>?) ?? [];

    // Convert each entry to BookWork
    return entries.map((e) {
      final m = Map<String, dynamic>.from(e as Map);

      return BookWork(
        key: m['key'] as String? ?? '',
        title: m['title'] as String? ?? '',
        authors:
            (m['author_name'] as List<dynamic>?)
                ?.map((a) => a.toString())
                .toList() ??
            [],
        firstPublishYear: (m['first_publish_year'] is num)
            ? (m['first_publish_year'] as num).toInt()
            : null,
        coverId: (m['cover_id'] is num) ? (m['cover_id'] as num).toInt() : null,
      );
    }).toList();
  }
}
