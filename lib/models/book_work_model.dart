
class BookWorkModel {
  final String? title;
  final String? key;
  final List<Authors>? authors;
  final Type1? type;
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

  /// Factory constructor with safe parsing
  factory BookWorkModel.fromJson(Map<String, dynamic> json) {
    return BookWorkModel(
      title: json["title"] as String?,
      key: json["key"] as String?,
      authors: (json["authors"] as List?)
          ?.map((e) => Authors.fromJson(e))
          .toList(),
      type: json["type"] != null ? Type1.fromJson(json["type"]) : null,
      description: _parseDescription(json["description"]),
      covers: (json["covers"] as List?)?.map((e) => e as int).toList(),
      subjectPlaces: (json["subject_places"] as List?)
          ?.map((e) => e as String)
          .toList(),
      subjects: (json["subjects"] as List?)?.map((e) => e as String).toList(),
      subjectPeople: (json["subject_people"] as List?)
          ?.map((e) => e as String)
          .toList(),
      subjectTimes: (json["subject_times"] as List?)
          ?.map((e) => e as String)
          .toList(),
      location: json["location"] as String?,
      latestRevision: json["latest_revision"] as int?,
      revision: json["revision"] as int?,
      created: json["created"] != null
          ? Created.fromJson(json["created"])
          : null,
      lastModified: json["last_modified"] != null
          ? LastModified.fromJson(json["last_modified"])
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

  /// Helper for safe description parsing
  static String? _parseDescription(dynamic description) {
    if (description == null) return null;
    if (description is String) return description;
    if (description is Map && description.containsKey("value")) {
      return description["value"] as String?;
    }
    return description.toString();
  }
}

class LastModified {
  final String? type;
  final String? value;

  LastModified({this.type, this.value});

  factory LastModified.fromJson(Map<String, dynamic> json) {
    return LastModified(
      type: json["type"] as String?,
      value: json["value"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {"type": type, "value": value};
}

class Created {
  final String? type;
  final String? value;

  Created({this.type, this.value});

  factory Created.fromJson(Map<String, dynamic> json) {
    return Created(
      type: json["type"] as String?,
      value: json["value"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {"type": type, "value": value};
}

class Type1 {
  final String? key;

  Type1({this.key});

  factory Type1.fromJson(Map<String, dynamic> json) {
    return Type1(key: json["key"] as String?);
  }

  Map<String, dynamic> toJson() => {"key": key};
}

class Authors {
  final Author? author;
  final Type? type;

  Authors({this.author, this.type});

  factory Authors.fromJson(Map<String, dynamic> json) {
    return Authors(
      author: json["author"] != null ? Author.fromJson(json["author"]) : null,
      type: json["type"] != null ? Type.fromJson(json["type"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "author": author?.toJson(),
    "type": type?.toJson(),
  };
}

class Type {
  final String? key;

  Type({this.key});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(key: json["key"] as String?);
  }

  Map<String, dynamic> toJson() => {"key": key};
}

class Author {
  final String? key;

  Author({this.key});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(key: json["key"] as String?);
  }

  Map<String, dynamic> toJson() => {"key": key};
}
