// lib/providers/subject_provider.dart
import 'package:flutter/material.dart';
import 'package:book_finder/repositories/subject_repository.dart';
import 'package:book_finder/models/book_work.dart';

/// Possible states for subject data
enum SubjectState { idle, loading, data, error }

/// Provider to manage subject details and its works
class SubjectProvider extends ChangeNotifier {
  SubjectState state = SubjectState.idle;
  String? errorMessage;
  String? subjectName;
  List<BookWork> works = [];

  /// Load books for a given subject
  Future<void> loadSubject(String subjectSlug) async {
    state = SubjectState.loading;
    errorMessage = null;
    works = [];
    notifyListeners();

    try {
      final result = await SubjectRepository.getSubject(subjectSlug);
      subjectName = result['subject'] as String?;
      works = result['works'] as List<BookWork>;
      state = SubjectState.data;
    } catch (e) {
      errorMessage = e.toString();
      state = SubjectState.error;
    }
    notifyListeners();
  }
}
