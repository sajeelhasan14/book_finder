import 'package:book_finder/services/api_services.dart';
import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'package:book_finder/core/constant.dart'; 

class OpenLibraryApi {
  // 🔍 SEARCH
  static Future<Response?> searchBooks(
    String query, {
    int page = 1,
    int limit = 20,
  }) {
    return DioClient.get(
      ApiService.search,
      queryParams: {"q": query, "page": page, "limit": limit},
    );
  }

  // 📖 WORK DETAILS
  static Future<Response> getWork(String workId) async {
  final resp = await DioClient.get(ApiService.workDetails(workId));
  if (resp == null) throw Exception("No response from getWork($workId)");
  return resp;
}

  // 📚 EDITIONS
  static Future<Response?> getEditions(
    String workId, {
    int limit = 20,
    int offset = 0,
  }) {
    return DioClient.get(
      ApiService.workEditions(workId, limit: limit, offset: offset),
    );
  }

  // 👤 AUTHOR DETAILS
  static Future<Response?> getAuthor(String authorId) {
    return DioClient.get(ApiService.authorDetails(authorId));
  }

  // 👤 AUTHOR WORKS
  static Future<Response?> getAuthorWorks(
    String authorId, {
    int limit = 50,
    int offset = 0,
  }) {
    return DioClient.get(
      ApiService.authorWorks(authorId, limit: limit, offset: offset),
    );
  }

  // 📂 SUBJECT BOOKS
  static Future<Response?> getSubjectBooks(
    String subject, {
    int limit = 25,
    bool details = true,
  }) {
    return DioClient.get(
      ApiService.subjectBooks(subject, limit: limit, details: details),
    );
  }

  // 🖼️ COVER (returns URL, not API call)
  static String getCoverUrl(int coverId, {String? size}) {
    final s = size ?? ApiConstants.defaultCoverSize; // use global default
    assert(
      s == ApiConstants.coverSmall ||
          s == ApiConstants.coverMedium ||
          s == ApiConstants.coverLarge,
      "Cover size must be S, M, or L",
    );
    return ApiService.coverFromId(coverId, size: s);
  }

  // 🖼️ AUTHOR PHOTO (returns URL, not API call)
  static String getAuthorPhoto(String authorId, {String? size}) {
    final s = size ?? ApiConstants.defaultCoverSize; // use global default
    assert(
      s == ApiConstants.coverSmall ||
          s == ApiConstants.coverMedium ||
          s == ApiConstants.coverLarge,
      "Cover size must be S, M, or L",
    );
    return ApiService.authorPhoto(authorId, size: s);
  }
// 🔥 Trending
static Future<Response?> getTrendingBooks() {
  return DioClient.get(ApiService.trending);
}


// 🆕 Recent (supports limit)
static Future<Response?> getRecentBooks({int limit = 10}) {
  return DioClient.get(ApiService.recent, queryParams: {"limit": limit});
}

}
