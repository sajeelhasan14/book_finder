import 'package:book_finder/core/constant.dart';

class ApiService {
  // Base URLs
  static const String baseUrl = ApiConstants.baseUrl;
  static const String coversBaseUrl = ApiConstants.coversBaseUrl;

  // ---------- SEARCH ----------
  // Example: /search.json?q=harry+potter
  static const String search = "$baseUrl/search.json";

  // ---------- WORKS ----------
  // Example: /works/OL45883W.json
  static String workDetails(String workId) => "$baseUrl/works/$workId.json";

  // Editions for a work
  // Example: /works/OL45883W/editions.json?limit=20&offset=0
  static String workEditions(String workId, {int limit = 20, int offset = 0}) =>
      "$baseUrl/works/$workId/editions.json?limit=$limit&offset=$offset";

  // ---------- AUTHORS ----------
  // Example: /authors/OL23919A.json
  static String authorDetails(String authorId) =>
      "$baseUrl/authors/$authorId.json";

  // Author works
  // Example: /authors/OL23919A/works.json?limit=50&offset=0
  static String authorWorks(
    String authorId, {
    int limit = 50,
    int offset = 0,
  }) => "$baseUrl/authors/$authorId/works.json?limit=$limit&offset=$offset";

  // ---------- SUBJECTS ----------
  // Example: /subjects/fantasy.json?details=true&limit=25
  static String subjectBooks(
    String subject, {
    int limit = 25,
    bool details = true,
  }) => "$baseUrl/subjects/$subject.json?details=$details&limit=$limit";

  // ---------- COVERS ----------
  // Example: https://covers.openlibrary.org/b/id/{coverId}-M.jpg
  static String coverFromId(int coverId, {String? size}) =>
      "$coversBaseUrl/b/id/$coverId-${size ?? ApiConstants.defaultCoverSize}.jpg";

  // Example: https://covers.openlibrary.org/a/olid/{authorId}-M.jpg
  static String authorPhoto(String authorId, {String? size}) =>
      "$coversBaseUrl/a/olid/$authorId-${size ?? ApiConstants.defaultCoverSize}.jpg";

  // 🔥 Trending
  static const String trending = "$baseUrl/trending/daily.json";

  
}
