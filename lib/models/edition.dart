// lib/models/edition.dart
class Edition {
  final String? key;
  final String? title;
  final List<String>? publishers;
  final String? publishDate;
  final List<String>? languages;
  final int? coverId;
  final int? numberOfPages;

  Edition({
    this.key,
    this.title,
    this.publishers,
    this.publishDate,
    this.languages,
    this.coverId,
    this.numberOfPages,
  });

  factory Edition.fromJson(Map<String, dynamic> json) {
    return Edition(
      key: json['key'] as String?,
      title: json['title'] as String?,
      publishers: (json['publishers'] as List<dynamic>?)?.map((e) => e?.toString() ?? '').toList(),
      publishDate: json['publish_date'] as String?,
      languages: (json['languages'] as List<dynamic>?)?.map((e) {
        if (e is Map && e['key'] != null) return e['key'].toString();
        return e?.toString() ?? '';
      }).where((s) => s.isNotEmpty).toList(),
      coverId: (json['covers'] is List && (json['covers'] as List).isNotEmpty) ? (json['covers'][0] as num?)?.toInt() : null,
      numberOfPages: (json['number_of_pages'] is num) ? (json['number_of_pages'] as num).toInt() : null,
    );
  }
}
