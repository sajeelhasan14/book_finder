// lib/providers/subject_provider.dart
import 'package:book_finder/models/subject_model.dart';
import 'package:flutter/material.dart';
import 'package:book_finder/repositories/subject_repository.dart';

class SubjectProvider extends ChangeNotifier {
  bool isLoading = false;             // Loader flag
  bool hasError = false;              // Error flag
  String? errorMessage;               // Stores error message if something fails
  String? subjectName;                // Name of the subject loaded from API
  List<Works> works = [];             // List of works under the subject

  // Load subject details and works from repository
  Future<void> loadSubject(String subjectSlug) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    works = []; // Reset previous works
    notifyListeners();

    try {
      final result = await SubjectRepository.getSubject(subjectSlug);

      subjectName = result['subject'] as String?;
      works = result['works'] as List<Works>;

      isLoading = false;
    } catch (e) {
      errorMessage = e.toString();
      hasError = true;
      isLoading = false;
    }

    notifyListeners(); // Final update for UI
  }
}
