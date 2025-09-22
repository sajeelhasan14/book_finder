// lib/models/author.dart
class AuthorModel {
  final String? key;
  final String? name;
  final String? bio;
  final List<int>? photos;

  AuthorModel({this.key, this.name, this.bio, this.photos});

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    String? parseBio(dynamic b) {
      if (b == null) return null;
      if (b is String) return b;
      if (b is Map && b['value'] != null) return b['value'] as String?;
      return b.toString();
    }

    return AuthorModel(
      key: json['key'] as String?,
      name: json['name'] as String?,
      bio: parseBio(json['bio']),
      photos: (json['photos'] as List<dynamic>?)?.map((e) {
        if (e is num) return e.toInt();
        return int.tryParse(e.toString());
      }).where((v) => v != null).map((v) => v as int).toList(),
    );
  }
}
