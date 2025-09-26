import 'package:book_finder/models/subject_model.dart';
import 'package:book_finder/services/open_library_api.dart';
import 'package:dio/dio.dart';

class SubjectRepository {
  // Get books under a specific subject
  static Future<Map<String, dynamic>> getSubject(
    String subject, {
    int limit = 25,
  }) async {
    final Response resp = await OpenLibraryApi.getSubject(
      subject,
      limit: limit,
      details: true,
    );
    final Map<String, dynamic> data = Map<String, dynamic>.from(
      resp.data as Map,
    );
    final worksRaw = (data['works'] as List<dynamic>?) ?? [];
   final works = worksRaw
    .map((w) => Works.fromJson(Map<String, dynamic>.from(w as Map)))
    .toList();
return {'subject': data['name'] as String?, 'works': works};
  }
}
