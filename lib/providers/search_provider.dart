// lib/providers/search_provider.dart
import 'package:flutter/material.dart';
import 'package:book_finder/models/book_work.dart';
import 'package:book_finder/repositories/book_repository.dart';

// 📌 Enum to represent the data state in UI
enum DataState { idle, loading, data, empty, error }

class SearchProvider extends ChangeNotifier {
  // Current state of search
  DataState state = DataState.idle;
  String errorMessage = '';

  // Search results
  List<BookWork> works = [];
  int page = 1;
  int limit = 20;
  int totalFound = 0;
  bool isLoadingMore = false;
  String currentQuery = '';

  // 🔎 Perform search query (reset = true means new search)
  Future<void> search(String query, {bool reset = true}) async {
    if (query.trim().isEmpty) return;

    if (reset) {
      state = DataState.loading;
      works = [];
      page = 1;
      totalFound = 0;
      currentQuery = query;
      notifyListeners();
    }

    try {
      final result = await BookRepository.search(query, page: page, limit: limit);
      final fetched = result['works'] as List<BookWork>;
      final found = result['numFound'] as int;

      if (fetched.isEmpty && page == 1) {
        state = DataState.empty; // No results
      } else {
        works.addAll(fetched);
        totalFound = found;
        state = DataState.data; // Successfully got data
      }
    } catch (e) {
      errorMessage = e.toString();
      state = DataState.error; // Error state
    }

    notifyListeners();
  }

  // ℹ️ Check if more results are available
  bool get hasMore => works.length < totalFound;

  // 📥 Load next page of results
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore) return;

    isLoadingMore = true;
    page += 1;
    notifyListeners();

    try {
      final result = await BookRepository.search(currentQuery, page: page, limit: limit);
      final fetched = result['works'] as List<BookWork>;
      works.addAll(fetched);
    } catch (e) {
      // Ignore pagination errors but record the message
      errorMessage = e.toString();
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  // 🧹 Clear search state
  void clear() {
    state = DataState.idle;
    works = [];
    currentQuery = '';
    page = 1;
    totalFound = 0;
    errorMessage = '';
    notifyListeners();
  }
}
