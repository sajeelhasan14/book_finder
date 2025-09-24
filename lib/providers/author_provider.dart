// lib/providers/author_provider.dart
import 'package:flutter/material.dart';
import 'package:book_finder/models/author.dart';
import 'package:book_finder/repositories/author_repository.dart';
import 'package:book_finder/models/book_work.dart';

// Enum for different states of author loading
// ✅ Keeps UI logic clean (instead of just bools).
enum AuthorState { idle, loading, data, error }

class AuthorProvider extends ChangeNotifier {
  AuthorState state = AuthorState.idle; // ✅ Starts idle
  String? errorMessage; // Holds error details
  AuthorModel? author; // Stores author details once loaded
  List<BookWork> works = []; // Stores the list of author's works

  // Loads both the author details and their works
  Future<void> loadAuthor(String authorId) async {
    state = AuthorState.loading; // ✅ Show loader in UI
    errorMessage = null;
    author = null;
    works = []; // Reset previous data
    notifyListeners(); // Tell listeners to rebuild

    try {
      // Fetch author details
      author = await AuthorRepository.getAuthor(authorId);

      // Fetch all works by this author
      works = await AuthorRepository.getAuthorWorks(authorId);

      state = AuthorState.data; // ✅ Data loaded successfully
    } catch (e) {
      errorMessage = e.toString(); // Save error for UI
      state = AuthorState.error;   // Switch to error state
    }
    notifyListeners(); // ✅ Trigger rebuild
  }
}
