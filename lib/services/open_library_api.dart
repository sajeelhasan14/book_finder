// lib/services/open_library_api.dart
import 'package:book_finder/core/constant.dart';
import 'package:book_finder/services/api_services.dart';
import 'package:dio/dio.dart';
import 'package:book_finder/services/dio_client.dart';


class OpenLibraryApi {
  // 🔎 Search books by query
  static Future<Response> searchBooks(String q, {int page = 1, int limit = 20}) =>
      DioClient.get(ApiService.search, queryParams: {"q": q, "page": page, "limit": limit});

  // 📘 Get details of a specific work (book)
  static Future<Response> getWork(String workId) =>
      DioClient.get(ApiService.workDetails(workId));

  // 📑 Get editions of a work
  static Future<Response> getEditions(String workId, {int limit = 20, int offset = 0}) =>
      DioClient.get(ApiService.workEditions(workId, limit: limit, offset: offset));

  // 👤 Get author details
  static Future<Response> getAuthor(String authorId) =>
      DioClient.get(ApiService.authorDetails(authorId));

  // 📚 Get works written by an author
  static Future<Response> getAuthorWorks(String authorId, {int limit = 50, int offset = 0}) =>
      DioClient.get(ApiService.authorWorks(authorId, limit: limit, offset: offset));

  // 🏷️ Get books by subject
  static Future<Response> getSubject(String subject, {int limit = 25, bool details = true}) =>
      DioClient.get(ApiService.subjectBooks(subject, limit: limit, details: details));

  // 🖼️ Convenience: build cover image URL
  static String getCoverUrl(int coverId, {String? size}) {
    final s = size ?? ApiConstants.defaultCoverSize;
    assert(s == ApiConstants.coverSmall || s == ApiConstants.coverMedium || s == ApiConstants.coverLarge);
    return ApiService.coverFromId(coverId, size: s);
  }

  // 🖼️ Convenience: build author photo URL
  static String getAuthorPhoto(String authorId, {String? size}) {
    final s = size ?? ApiConstants.defaultCoverSize;
    assert(s == ApiConstants.coverSmall || s == ApiConstants.coverMedium || s == ApiConstants.coverLarge);
    return ApiService.authorPhoto(authorId, size: s);
  }
  static Future<Response?> getTrendingBooks() {
  return DioClient.get(ApiService.trending);
}
}
