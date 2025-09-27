class AuthorModel {
  String? name;
  Bio? bio;
  RemoteIds? remoteIds;
  List<int>? photos;
  List<String>? alternateNames;
  List<Links>? links;
  List<String>? sourceRecords;
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
    this.photos,
    this.alternateNames,
    this.links,
    this.sourceRecords,
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

  AuthorModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    bio = json['bio'] != null ? Bio.fromJson(json['bio']) : null;
    remoteIds = json['remote_ids'] != null
        ? RemoteIds.fromJson(json['remote_ids'])
        : null;
    photos = json['photos'].cast<int>();
    alternateNames = json['alternate_names'].cast<String>();
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    sourceRecords = json['source_records'].cast<String>();
    entityType = json['entity_type'];
    birthDate = json['birth_date'];
    fullerName = json['fuller_name'];
    title = json['title'];
    type = json['type'] != null ? Type.fromJson(json['type']) : null;
    personalName = json['personal_name'];
    key = json['key'];
    latestRevision = json['latest_revision'];
    revision = json['revision'];
    created = json['created'] != null ? Bio.fromJson(json['created']) : null;
    lastModified = json['last_modified'] != null
        ? Bio.fromJson(json['last_modified'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (bio != null) {
      data['bio'] = bio!.toJson();
    }
    if (remoteIds != null) {
      data['remote_ids'] = remoteIds!.toJson();
    }
    data['photos'] = photos;
    data['alternate_names'] = alternateNames;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['source_records'] = sourceRecords;
    data['entity_type'] = entityType;
    data['birth_date'] = birthDate;
    data['fuller_name'] = fullerName;
    data['title'] = title;
    if (type != null) {
      data['type'] = type!.toJson();
    }
    data['personal_name'] = personalName;
    data['key'] = key;
    data['latest_revision'] = latestRevision;
    data['revision'] = revision;
    if (created != null) {
      data['created'] = created!.toJson();
    }
    if (lastModified != null) {
      data['last_modified'] = lastModified!.toJson();
    }
    return data;
  }
}

class Bio {
  String? type;
  String? value;

  Bio({this.type, this.value});

  Bio.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['value'] = value;
    return data;
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

  RemoteIds.fromJson(Map<String, dynamic> json) {
    viaf = json['viaf'];
    goodreads = json['goodreads'];
    storygraph = json['storygraph'];
    isni = json['isni'];
    librarything = json['librarything'];
    amazon = json['amazon'];
    wikidata = json['wikidata'];
    imdb = json['imdb'];
    musicbrainz = json['musicbrainz'];
    lcNaf = json['lc_naf'];
    opacSbn = json['opac_sbn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['viaf'] = viaf;
    data['goodreads'] = goodreads;
    data['storygraph'] = storygraph;
    data['isni'] = isni;
    data['librarything'] = librarything;
    data['amazon'] = amazon;
    data['wikidata'] = wikidata;
    data['imdb'] = imdb;
    data['musicbrainz'] = musicbrainz;
    data['lc_naf'] = lcNaf;
    data['opac_sbn'] = opacSbn;
    return data;
  }
}

class Links {
  String? title;
  String? url;
  Type? type;

  Links({this.title, this.url, this.type});

  Links.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
    type = json['type'] != null ? Type.fromJson(json['type']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['url'] = url;
    if (type != null) {
      data['type'] = type!.toJson();
    }
    return data;
  }
}

class Type {
  String? key;

  Type({this.key});

  Type.fromJson(Map<String, dynamic> json) {
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    return data;
  }
}
