/// A lightweight model that represents a book work from the search API.
/// This model is optimized for `/search.json` results where only limited
/// information is available.
class BookWork {
  /// Unique key for the work (e.g. "/works/OL45883W").
  final String key;

  /// Title of the work.
  final String title;

  /// List of author names.
  final List<String> authors;

  /// First year of publication (if available).
  final int? firstPublishYear;

  /// Cover ID (used for fetching cover images).
  final int? coverId;

  BookWork({
    required this.key,
    required this.title,
    required this.authors,
    this.firstPublishYear,
    this.coverId,
  });

  /// Factory constructor to build a [BookWork] from search results JSON.
  factory BookWork.fromSearchJson(Map<String, dynamic> json) {
    return BookWork(
      key: json['key'] as String? ?? '',
      title: json['title'] as String? ?? '',
      authors: (json['author_name'] as List<dynamic>?)
              ?.map((e) => e?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .toList() ??
          [],
      firstPublishYear: json['first_publish_year'] != null
          ? (json['first_publish_year'] as num).toInt()
          : null,
      coverId: json['cover_i'] != null ? (json['cover_i'] as num).toInt() : null,
    );
  }

  /// Converts the object back into JSON format.
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title': title,
      'author_name': authors,
      'first_publish_year': firstPublishYear,
      'cover_i': coverId,
    };
  }

  /// Extracts the plain work ID from the key.
  /// Example: "/works/OL45883W" → "OL45883W".
  String get workId {
    if (key.startsWith('/works/')) return key.replaceFirst('/works/', '');
    return key;
  }
}
