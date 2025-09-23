// lib/repositories/book_repository.dart

import 'package:dio/dio.dart';
import 'package:book_finder/services/open_library_api.dart';
import 'package:book_finder/models/book_work.dart';
import 'package:book_finder/models/book_work_model.dart';
import 'package:book_finder/models/edition.dart';

class BookRepository {
  // Search for books by query
  static Future<Map<String, dynamic>> search(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    final resp = await OpenLibraryApi.searchBooks(
      query,
      page: page,
      limit: limit,
    );
    final data = resp?.data as Map<String, dynamic>;
    final docs = (data['docs'] as List<dynamic>?) ?? [];
    final works = docs
        .map(
          (d) => BookWork.fromSearchJson(Map<String, dynamic>.from(d as Map)),
        )
        .toList();
    final numFound = (data['numFound'] is num)
        ? (data['numFound'] as num).toInt()
        : works.length;
    return {'works': works, 'numFound': numFound};
  }

  // Get detailed info of a single work by ID
  static Future<BookWorkModel> getWork(String workId) async {
    final Response resp = await OpenLibraryApi.getWork(workId);
    if (resp.data == null) throw Exception('Empty response for work $workId');
    final Map<String, dynamic> data = Map<String, dynamic>.from(
      resp.data as Map,
    );
    return BookWorkModel.fromJson(data);
  }

  // Get all editions of a work
  static Future<List<Edition>> getEditions(
    String workId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final resp = await OpenLibraryApi.getEditions(
      workId,
      limit: limit,
      offset: offset,
    );
    final data = resp?.data as Map<String, dynamic>;
    final entries = (data['entries'] as List<dynamic>?) ?? [];
    return entries
        .map((e) => Edition.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

 // 🔥 Trending books
static Future<List<BookWork>> getTrendingBooks({int limit = 10}) async {
  final resp = await OpenLibraryApi.getTrendingBooks(); // no limit param
  if (resp?.data == null) return [];
  final data = resp!.data as Map<String, dynamic>;
  final works = (data['works'] as List<dynamic>? ?? []);
  return works
      .map((d) => BookWork.fromSearchJson(Map<String, dynamic>.from(d as Map)))
      .take(limit) // manually limit the results
      .toList();
}

// 🆕 Recently added books
static Future<List<BookWork>> getRecentBooks({int limit = 10}) async {
  final resp = await OpenLibraryApi.getRecentBooks(limit: limit); // supported
  if (resp?.data == null) return [];
  final data = resp!.data as List<dynamic>; // recentchanges returns a list
  return data
      .take(limit)
      .map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        final work = map['data']?['works']?[0];
        if (work is Map) {
          return BookWork.fromSearchJson(Map<String, dynamic>.from(work));
        }
        return null;
      })
      .where((e) => e != null)
      .cast<BookWork>()
      .toList();
}


}
