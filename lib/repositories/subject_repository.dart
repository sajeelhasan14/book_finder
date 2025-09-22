import 'package:book_finder/services/open_library_api.dart';
import 'package:book_finder/models/book_work.dart';

class SubjectRepository {
  // Get books under a specific subject
  static Future<Map<String, dynamic>> getSubject(String subject, {int limit = 25}) async {
    final resp = await OpenLibraryApi.getSubjectBooks(subject, limit: limit, details: true);
    final Map<String, dynamic> data = Map<String, dynamic>.from(resp?.data as Map);

    // Extract and map works
    final worksRaw = (data['works'] as List<dynamic>?) ?? [];
    final works = worksRaw.map((w) => BookWork.fromSearchJson(Map<String, dynamic>.from(w as Map))).toList();

    // Return subject name and list of works
    return {'subject': data['name'] as String?, 'works': works};
  }
}
