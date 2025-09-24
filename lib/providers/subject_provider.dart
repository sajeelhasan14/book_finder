// lib/providers/subject_provider.dart
import 'package:flutter/material.dart';
import 'package:book_finder/repositories/subject_repository.dart';
import 'package:book_finder/models/book_work.dart';

// Enum for different states of subject loading
// ✅ Keeps UI updates simple (idle, loading, data, error).
enum SubjectState { idle, loading, data, error }

class SubjectProvider extends ChangeNotifier {
  SubjectState state = SubjectState.idle; // Initial state
  String? errorMessage;                   // Stores error message if something fails
  String? subjectName;                    // Name of the subject loaded from API
  List<BookWork> works = [];              // List of works under the subject

  // Load subject details and works from repository
  Future<void> loadSubject(String subjectSlug) async {
    state = SubjectState.loading;   // ✅ Show loader in UI
    errorMessage = null;
    works = [];                     // Reset previous works
    notifyListeners();              // Inform UI of state change

    try {
      // Call repository to get subject info + works
      final result = await SubjectRepository.getSubject(subjectSlug);

      subjectName = result['subject'] as String?;      // Extract subject name
      works = result['works'] as List<BookWork>;       // Extract works list

      state = SubjectState.data;       // ✅ Success
    } catch (e) {
      errorMessage = e.toString();     // Capture error for UI
      state = SubjectState.error;      // Switch to error state
    }
    notifyListeners();                 // Notify listeners for final state
  }
}
