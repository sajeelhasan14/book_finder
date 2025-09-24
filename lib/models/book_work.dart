// lib/models/book_work.dart
class BookWork {
  final String key;
  final String title;
  final List<String> authors;
  final int? firstPublishYear;
  final int? coverId;

  BookWork({
    required this.key,
    required this.title,
    required this.authors,
    this.firstPublishYear,
    this.coverId,
  });

  factory BookWork.fromSearchJson(Map<String, dynamic> json) {
    return BookWork(
      key: json['key'] as String? ?? '',
      title: json['title'] as String? ?? '',
      authors: (json['author_name'] as List<dynamic>?)?.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList() ?? [],
      firstPublishYear: (json['first_publish_year'] is num) ? (json['first_publish_year'] as num).toInt() : null,
      coverId: (json['cover_i'] is num) ? (json['cover_i'] as num).toInt() : null,
    );
  }

  String get workId => key.startsWith('/works/') ? key.replaceFirst('/works/', '') : key;
}
