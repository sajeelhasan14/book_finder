class AuthorModel {
  String? name;
  Bio? bio;
  RemoteIds? remoteIds;
  List<int> photos;
  List<String> alternateNames;
  List<Links> links;
  List<String> sourceRecords;
  String? entityType;
  String? birthDate;
  String? fullerName;
  String? title;
  Type? type;
  String? personalName;
  String? key;
  int? latestRevision;
  int? revision;
  Bio? created;
  Bio? lastModified;

  AuthorModel({
    this.name,
    this.bio,
    this.remoteIds,
    this.photos = const [],
    this.alternateNames = const [],
    this.links = const [],
    this.sourceRecords = const [],
    this.entityType,
    this.birthDate,
    this.fullerName,
    this.title,
    this.type,
    this.personalName,
    this.key,
    this.latestRevision,
    this.revision,
    this.created,
    this.lastModified,
  });

  AuthorModel.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      bio = json['bio'] != null ? Bio.fromJson(json['bio']) : null,
      remoteIds = json['remote_ids'] != null
          ? RemoteIds.fromJson(json['remote_ids'])
          : null,
      photos = json['photos'] != null
          ? List<int>.from(json['photos'])
          : <int>[],
      alternateNames = json['alternate_names'] != null
          ? List<String>.from(json['alternate_names'])
          : <String>[],
      links = json['links'] != null
          ? (json['links'] as List).map((v) => Links.fromJson(v)).toList()
          : <Links>[],
      sourceRecords = json['source_records'] != null
          ? List<String>.from(json['source_records'])
          : <String>[],
      entityType = json['entity_type'],
      birthDate = json['birth_date'],
      fullerName = json['fuller_name'],
      title = json['title'],
      type = json['type'] != null ? Type.fromJson(json['type']) : null,
      personalName = json['personal_name'],
      key = json['key'],
      latestRevision = json['latest_revision'],
      revision = json['revision'],
      created = json['created'] != null ? Bio.fromJson(json['created']) : null,
      lastModified = json['last_modified'] != null
          ? Bio.fromJson(json['last_modified'])
          : null;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (bio != null) 'bio': bio!.toJson(),
      if (remoteIds != null) 'remote_ids': remoteIds!.toJson(),
      'photos': photos,
      'alternate_names': alternateNames,
      'links': links.map((v) => v.toJson()).toList(),
      'source_records': sourceRecords,
      'entity_type': entityType,
      'birth_date': birthDate,
      'fuller_name': fullerName,
      'title': title,
      if (type != null) 'type': type!.toJson(),
      'personal_name': personalName,
      'key': key,
      'latest_revision': latestRevision,
      'revision': revision,
      if (created != null) 'created': created!.toJson(),
      if (lastModified != null) 'last_modified': lastModified!.toJson(),
    };
  }
}

class Bio {
  String? type;
  String? value;

  Bio({this.type, this.value});

  Bio.fromJson(Map<String, dynamic> json)
    : type = json['type'],
      value = json['value'];

  Map<String, dynamic> toJson() {
    return {'type': type, 'value': value};
  }
}

class RemoteIds {
  String? viaf;
  String? goodreads;
  String? storygraph;
  String? isni;
  String? librarything;
  String? amazon;
  String? wikidata;
  String? imdb;
  String? musicbrainz;
  String? lcNaf;
  String? opacSbn;

  RemoteIds({
    this.viaf,
    this.goodreads,
    this.storygraph,
    this.isni,
    this.librarything,
    this.amazon,
    this.wikidata,
    this.imdb,
    this.musicbrainz,
    this.lcNaf,
    this.opacSbn,
  });

  RemoteIds.fromJson(Map<String, dynamic> json)
    : viaf = json['viaf'],
      goodreads = json['goodreads'],
      storygraph = json['storygraph'],
      isni = json['isni'],
      librarything = json['librarything'],
      amazon = json['amazon'],
      wikidata = json['wikidata'],
      imdb = json['imdb'],
      musicbrainz = json['musicbrainz'],
      lcNaf = json['lc_naf'],
      opacSbn = json['opac_sbn'];

  Map<String, dynamic> toJson() {
    return {
      'viaf': viaf,
      'goodreads': goodreads,
      'storygraph': storygraph,
      'isni': isni,
      'librarything': librarything,
      'amazon': amazon,
      'wikidata': wikidata,
      'imdb': imdb,
      'musicbrainz': musicbrainz,
      'lc_naf': lcNaf,
      'opac_sbn': opacSbn,
    };
  }
}

class Links {
  String? title;
  String? url;
  Type? type;

  Links({this.title, this.url, this.type});

  Links.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      url = json['url'],
      type = json['type'] != null ? Type.fromJson(json['type']) : null;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      if (type != null) 'type': type!.toJson(),
    };
  }
}

class Type {
  String? key;

  Type({this.key});

  Type.fromJson(Map<String, dynamic> json) : key = json['key'];

  Map<String, dynamic> toJson() {
    return {'key': key};
  }
}
