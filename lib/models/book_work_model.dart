/// A detailed model that represents a single work fetched from
/// `/works/{id}.json`. This includes metadata like subjects, authors,
/// covers, and timestamps.
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

  /// Factory constructor for safe parsing of `/works/{id}.json`.
  factory BookWorkModel.fromJson(Map<String, dynamic> json) {
    List<T>? _listOf<T>(dynamic v, T Function(dynamic) mapFn) {
      if (v == null) return null;
      if (v is List) return v.map(mapFn).toList();
      return null;
    }

    List<int>? _covers(dynamic v) {
      if (v == null) return null;
      if (v is List) {
        return v
            .map((e) => (e is int) ? e : int.tryParse(e.toString()))
            .where((e) => e != null)
            .map((e) => e!)
            .toList();
      }
      return null;
    }

    return BookWorkModel(
      title: json["title"] as String?,
      key: json["key"] as String?,
      authors: _listOf<Authors>(json["authors"],
          (e) => Authors.fromJson(Map<String, dynamic>.from(e as Map))),
      type: json["type"] != null
          ? WorkType.fromJson(Map<String, dynamic>.from(json["type"] as Map))
          : null,
      description: _parseDescription(json["description"]),
      covers: _covers(json["covers"]),
      subjectPlaces:
          _listOf<String>(json["subject_places"], (e) => e.toString()),
      subjects: _listOf<String>(json["subjects"], (e) => e.toString()),
      subjectPeople:
          _listOf<String>(json["subject_people"], (e) => e.toString()),
      subjectTimes:
          _listOf<String>(json["subject_times"], (e) => e.toString()),
      location: json["location"] as String?,
      latestRevision: (json["latest_revision"] is num)
          ? (json["latest_revision"] as num).toInt()
          : null,
      revision:
          (json["revision"] is num) ? (json["revision"] as num).toInt() : null,
      created: json["created"] != null
          ? Created.fromJson(Map<String, dynamic>.from(json["created"] as Map))
          : null,
      lastModified: json["last_modified"] != null
          ? LastModified.fromJson(
              Map<String, dynamic>.from(json["last_modified"] as Map))
          : null,
    );
  }

  /// Converts this object back into JSON.
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

  /// Handles description safely (string or object).
  static String? _parseDescription(dynamic description) {
    if (description == null) return null;
    if (description is String) return description;
    if (description is Map && description.containsKey("value")) {
      return description["value"] as String?;
    }
    return description.toString();
  }

  /// Returns the first cover ID (useful for images).
  int? get firstCoverId =>
      covers != null && covers!.isNotEmpty ? covers!.first : null;

  /// Returns the list of author keys (OL IDs).
  List<String> get authorKeys => authors
          ?.map((a) => a.author?.key)
          .where((k) => k != null && k!.isNotEmpty)
          .map((k) => k!.replaceAll('/authors/', ''))
          .toList() ??
      [];
}

/* -------- Nested classes for BookWorkModel -------- */

class LastModified {
  final String? type;
  final String? value;
  LastModified({this.type, this.value});
  factory LastModified.fromJson(Map<String, dynamic> json) =>
      LastModified(type: json["type"], value: json["value"]);
  Map<String, dynamic> toJson() => {"type": type, "value": value};
}

class Created {
  final String? type;
  final String? value;
  Created({this.type, this.value});
  factory Created.fromJson(Map<String, dynamic> json) =>
      Created(type: json["type"], value: json["value"]);
  Map<String, dynamic> toJson() => {"type": type, "value": value};
}

class WorkType {
  final String? key;
  WorkType({this.key});
  factory WorkType.fromJson(Map<String, dynamic> json) =>
      WorkType(key: json["key"]);
  Map<String, dynamic> toJson() => {"key": key};
}

class Authors {
  final Author? author;
  final AuthorType? type;
  Authors({this.author, this.type});
  factory Authors.fromJson(Map<String, dynamic> json) => Authors(
        author: json["author"] != null
            ? Author.fromJson(Map<String, dynamic>.from(json["author"]))
            : null,
        type: json["type"] != null
            ? AuthorType.fromJson(Map<String, dynamic>.from(json["type"]))
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
      AuthorType(key: json["key"]);
  Map<String, dynamic> toJson() => {"key": key};
}

class Author {
  final String? key;
  Author({this.key});
  factory Author.fromJson(Map<String, dynamic> json) => Author(key: json["key"]);
  Map<String, dynamic> toJson() => {"key": key};
}
