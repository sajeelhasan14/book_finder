// lib/providers/editions_provider.dart
import 'package:flutter/material.dart';
import 'package:book_finder/models/edition.dart';
import 'package:book_finder/repositories/book_repository.dart';

// Enum representing the possible states of the editions loading process.
// ✅ Good: makes UI logic much cleaner compared to using only bools.
enum EditionsState { idle, loading, data, error, empty }

class EditionsProvider extends ChangeNotifier {
  EditionsState state = EditionsState.idle; // ✅ Initial state is idle
  String? errorMessage; // Holds error details if something fails
  List<Edition> editions = []; // List to hold fetched editions
  int limit = 20; // Pagination limit
  int offset = 0; // Pagination offset
  bool isLoadingMore =
      false; // Prevents multiple "load more" calls simultaneously

  // Main method to load editions (fresh load or reset if needed)
  Future<void> loadEditions(String workId, {bool reset = true}) async {
    print(editions);
    if (reset) {
      state = EditionsState.loading; // ✅ UI will show loader
      editions = []; // Clear previous editions
      offset = 0; // Reset pagination
      notifyListeners();
    }
    try {
      // Fetch editions from repository with pagination
      final fetched = await BookRepository.getEditions(
        workId,
        limit: limit,
        offset: offset,
      );

      // If nothing comes back on the first load → show empty state
      if (fetched.isEmpty && offset == 0) {
        state = EditionsState.empty;
      } else {
        editions.addAll(fetched); // Add new results
        state = EditionsState.data; // ✅ Mark as data loaded
        offset += fetched.length; // Advance pagination offset
      }
    } catch (e) {
      errorMessage = e.toString(); // Store error message
      state = EditionsState.error; // ✅ Switch to error state
    }
    notifyListeners(); // ✅ Notify widgets about state changes
  }

  // Method to load additional editions (pagination "load more")
  Future<void> loadMore(String workId) async {
    if (isLoadingMore) return; // ✅ Prevent duplicate concurrent loads
    isLoadingMore = true;
    notifyListeners();

    try {
      final fetched = await BookRepository.getEditions(
        workId,
        limit: limit,
        offset: offset,
      );
      editions.addAll(fetched);
      offset += fetched.length;
      // ⚠️ Suggestion: handle the case when `fetched` is empty (no more data).
    } catch (e) {
      errorMessage = e.toString(); // Log/handle error
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}
