// lib/models/book_work_model.dart
class BookWorkModel {
  final String? title;
  final String? key;
  final List<Authors>? authors;
  final WorkType? type;
  final String? description;
  final List<int>? covers;
  final List<String>? subjectPlaces;
  final List<String>? subjects;
  final List<String>? subjectPeople;
  final List<String>? subjectTimes;
  final String? location;
  final int? latestRevision;
  final int? revision;
  final Created? created;
  final LastModified? lastModified;

  BookWorkModel({
    this.title,
    this.key,
    this.authors,
    this.type,
    this.description,
    this.covers,
    this.subjectPlaces,
    this.subjects,
    this.subjectPeople,
    this.subjectTimes,
    this.location,
    this.latestRevision,
    this.revision,
    this.created,
    this.lastModified,
  });

  factory BookWorkModel.fromJson(Map<String, dynamic> json) {
    List<T>? listOf<T>(dynamic v, T Function(dynamic) mapFn) {
      if (v == null) return null;
      if (v is List) return v.map(mapFn).toList();
      return null;
    }

    List<int>? covers(dynamic v) {
      if (v == null) return null;
      if (v is List) {
        final converted = v
            .map((e) {
              if (e == null) return null;
              if (e is int) return e;
              if (e is num) return e.toInt();
              return int.tryParse(e.toString());
            })
            .where((e) => e != null)
            .map((e) => e as int)
            .toList();
        return converted;
      }
      return null;
    }

    return BookWorkModel(
      title: json["title"] as String?,
      key: json["key"] as String?,
      authors: listOf<Authors>(
        json["authors"],
        (e) => Authors.fromJson(Map<String, dynamic>.from(e as Map)),
      ),
      type: json["type"] != null
          ? WorkType.fromJson(Map<String, dynamic>.from(json["type"] as Map))
          : null,
      description: _parseDescription(json["description"]),
      covers: covers(json["covers"]),
      subjectPlaces: listOf<String>(
        json["subject_places"],
        (e) => e?.toString() ?? '',
      )?.where((s) => s.isNotEmpty).toList(),
      subjects: listOf<String>(
        json["subjects"],
        (e) => e?.toString() ?? '',
      )?.where((s) => s.isNotEmpty).toList(),
      subjectPeople: listOf<String>(
        json["subject_people"],
        (e) => e?.toString() ?? '',
      )?.where((s) => s.isNotEmpty).toList(),
      subjectTimes: listOf<String>(
        json["subject_times"],
        (e) => e?.toString() ?? '',
      )?.where((s) => s.isNotEmpty).toList(),
      location: json["location"] as String?,
      latestRevision: (json["latest_revision"] is num)
          ? (json["latest_revision"] as num).toInt()
          : (json["latest_revision"] as int?),
      revision: (json["revision"] is num)
          ? (json["revision"] as num).toInt()
          : (json["revision"] as int?),
      created: json["created"] != null
          ? Created.fromJson(Map<String, dynamic>.from(json["created"] as Map))
          : null,
      lastModified: json["last_modified"] != null
          ? LastModified.fromJson(
              Map<String, dynamic>.from(json["last_modified"] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "key": key,
      "authors": authors?.map((e) => e.toJson()).toList(),
      "type": type?.toJson(),
      "description": description,
      "covers": covers,
      "subject_places": subjectPlaces,
      "subjects": subjects,
      "subject_people": subjectPeople,
      "subject_times": subjectTimes,
      "location": location,
      "latest_revision": latestRevision,
      "revision": revision,
      "created": created?.toJson(),
      "last_modified": lastModified?.toJson(),
    };
  }

  static String? _parseDescription(dynamic description) {
    if (description == null) return null;
    if (description is String) return description;
    if (description is Map && description.containsKey("value")) {
      return description["value"] as String?;
    }
    return description.toString();
  }

  int? get firstCoverId =>
      covers != null && covers!.isNotEmpty ? covers!.first : null;

  List<String> get authorKeys =>
      authors
          ?.map((a) => a.author?.key)
          .where((k) => k != null && k.isNotEmpty)
          .map((k) => k!.replaceAll('/authors/', ''))
          .toList() ??
      [];
}

class LastModified {
  final String? type;
  final String? value;
  LastModified({this.type, this.value});
  factory LastModified.fromJson(Map<String, dynamic> json) => LastModified(
    type: json["type"] as String?,
    value: json["value"] as String?,
  );
  Map<String, dynamic> toJson() => {"type": type, "value": value};
}

class Created {
  final String? type;
  final String? value;
  Created({this.type, this.value});
  factory Created.fromJson(Map<String, dynamic> json) =>
      Created(type: json["type"] as String?, value: json["value"] as String?);
  Map<String, dynamic> toJson() => {"type": type, "value": value};
}

class WorkType {
  final String? key;
  WorkType({this.key});
  factory WorkType.fromJson(Map<String, dynamic> json) =>
      WorkType(key: json["key"] as String?);
  Map<String, dynamic> toJson() => {"key": key};
}

class Authors {
  final Author? author;
  final AuthorType? type;
  Authors({this.author, this.type});
  factory Authors.fromJson(Map<String, dynamic> json) => Authors(
    author: json["author"] != null
        ? Author.fromJson(Map<String, dynamic>.from(json["author"] as Map))
        : null,
    type: json["type"] != null
        ? AuthorType.fromJson(Map<String, dynamic>.from(json["type"] as Map))
        : null,
  );
  Map<String, dynamic> toJson() => {
    "author": author?.toJson(),
    "type": type?.toJson(),
  };
}

class AuthorType {
  final String? key;
  AuthorType({this.key});
  factory AuthorType.fromJson(Map<String, dynamic> json) =>
      AuthorType(key: json["key"] as String?);
  Map<String, dynamic> toJson() => {"key": key};
}

class Author {
  final String? key;
  Author({this.key});
  factory Author.fromJson(Map<String, dynamic> json) =>
      Author(key: json["key"] as String?);
  Map<String, dynamic> toJson() => {"key": key};
}
