// ignore_for_file: unnecessary_question_mark

class SubjectModel {
  String? key;
  String? name;
  String? subjectType;
  String? solrQuery;
  int? workCount;
  List<Works>? works;

  SubjectModel(
      {this.key,
      this.name,
      this.subjectType,
      this.solrQuery,
      this.workCount,
      this.works});

  SubjectModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    subjectType = json['subject_type'];
    solrQuery = json['solr_query'];
    workCount = json['work_count'];
    if (json['works'] != null) {
      works = <Works>[];
      json['works'].forEach((v) {
        works!.add(Works.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['name'] = name;
    data['subject_type'] = subjectType;
    data['solr_query'] = solrQuery;
    data['work_count'] = workCount;
    if (works != null) {
      data['works'] = works!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Works {
  String? key;
  String? title;
  int? editionCount;
  int? coverId;
  String? coverEditionKey;
  List<String>? subject;
  List<String>? iaCollection;
  bool? printdisabled;
  String? lendingEdition;
  String? lendingIdentifier;
  List<Authors>? authors;
  int? firstPublishYear;
  String? ia;
  bool? publicScan;
  bool? hasFulltext;
  Availability? availability;

  Works(
      {this.key,
      this.title,
      this.editionCount,
      this.coverId,
      this.coverEditionKey,
      this.subject,
      this.iaCollection,
      this.printdisabled,
      this.lendingEdition,
      this.lendingIdentifier,
      this.authors,
      this.firstPublishYear,
      this.ia,
      this.publicScan,
      this.hasFulltext,
      this.availability});

  Works.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    title = json['title'];
    editionCount = json['edition_count'];
    coverId = json['cover_id'];
    coverEditionKey = json['cover_edition_key'];
    subject = json['subject'].cast<String>();
    iaCollection = json['ia_collection'].cast<String>();
    printdisabled = json['printdisabled'];
    lendingEdition = json['lending_edition'];
    lendingIdentifier = json['lending_identifier'];
    if (json['authors'] != null) {
      authors = <Authors>[];
      json['authors'].forEach((v) {
        authors!.add(Authors.fromJson(v));
      });
    }
    firstPublishYear = json['first_publish_year'];
    ia = json['ia'];
    publicScan = json['public_scan'];
    hasFulltext = json['has_fulltext'];
    availability = json['availability'] != null
        ? Availability.fromJson(json['availability'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['title'] = title;
    data['edition_count'] = editionCount;
    data['cover_id'] = coverId;
    data['cover_edition_key'] = coverEditionKey;
    data['subject'] = subject;
    data['ia_collection'] = iaCollection;
    data['printdisabled'] = printdisabled;
    data['lending_edition'] = lendingEdition;
    data['lending_identifier'] = lendingIdentifier;
    if (authors != null) {
      data['authors'] = authors!.map((v) => v.toJson()).toList();
    }
    data['first_publish_year'] = firstPublishYear;
    data['ia'] = ia;
    data['public_scan'] = publicScan;
    data['has_fulltext'] = hasFulltext;
    if (availability != null) {
      data['availability'] = availability!.toJson();
    }
    return data;
  }
}

class Authors {
  String? key;
  String? name;

  Authors({this.key, this.name});

  Authors.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['name'] = name;
    return data;
  }
}

class Availability {
  String? status;
  bool? availableToBrowse;
  bool? availableToBorrow;
  bool? availableToWaitlist;
  bool? isPrintdisabled;
  bool? isReadable;
  bool? isLendable;
  bool? isPreviewable;
  String? identifier;
  String? isbn;
  Null? oclc;
  String? openlibraryWork;
  String? openlibraryEdition;
  Null lastLoanDate;
  Null? numWaitlist;
  Null? lastWaitlistDate;
  bool? isRestricted;
  bool? isBrowseable;
  String? sSrc;

  Availability(
      {this.status,
      this.availableToBrowse,
      this.availableToBorrow,
      this.availableToWaitlist,
      this.isPrintdisabled,
      this.isReadable,
      this.isLendable,
      this.isPreviewable,
      this.identifier,
      this.isbn,
      this.oclc,
      this.openlibraryWork,
      this.openlibraryEdition,
      this.lastLoanDate,
      this.numWaitlist,
      this.lastWaitlistDate,
      this.isRestricted,
      this.isBrowseable,
      this.sSrc});

  Availability.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    availableToBrowse = json['available_to_browse'];
    availableToBorrow = json['available_to_borrow'];
    availableToWaitlist = json['available_to_waitlist'];
    isPrintdisabled = json['is_printdisabled'];
    isReadable = json['is_readable'];
    isLendable = json['is_lendable'];
    isPreviewable = json['is_previewable'];
    identifier = json['identifier'];
    isbn = json['isbn'];
    oclc = json['oclc'];
    openlibraryWork = json['openlibrary_work'];
    openlibraryEdition = json['openlibrary_edition'];
    lastLoanDate = json['last_loan_date'];
    numWaitlist = json['num_waitlist'];
    lastWaitlistDate = json['last_waitlist_date'];
    isRestricted = json['is_restricted'];
    isBrowseable = json['is_browseable'];
    sSrc = json['__src__'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['available_to_browse'] = availableToBrowse;
    data['available_to_borrow'] = availableToBorrow;
    data['available_to_waitlist'] = availableToWaitlist;
    data['is_printdisabled'] = isPrintdisabled;
    data['is_readable'] = isReadable;
    data['is_lendable'] = isLendable;
    data['is_previewable'] = isPreviewable;
    data['identifier'] = identifier;
    data['isbn'] = isbn;
    data['oclc'] = oclc;
    data['openlibrary_work'] = openlibraryWork;
    data['openlibrary_edition'] = openlibraryEdition;
    data['last_loan_date'] = lastLoanDate;
    data['num_waitlist'] = numWaitlist;
    data['last_waitlist_date'] = lastWaitlistDate;
    data['is_restricted'] = isRestricted;
    data['is_browseable'] = isBrowseable;
    data['__src__'] = sSrc;
    return data;
  }
}