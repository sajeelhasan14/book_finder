import 'package:book_finder/models/book_work.dart';

extension BookWorkAuthorExtractor on BookWork {
  /// Extracts the first authorId from the key
  String? getFirstAuthorId() {
    if (authors.isNotEmpty) {
      // Example: "/authors/OL12345A"
      final rawKey = authors.first;
      // Clean up to just "OL12345A"
      return rawKey.replaceFirst("/authors/", "");
    }
    return null;
  }
}
