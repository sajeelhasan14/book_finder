// lib/providers/search_provider.dart

import 'package:book_finder/models/book_work_model.dart';
import 'package:flutter/material.dart';

import 'package:book_finder/repositories/book_repository.dart';

// States for handling search data flow
enum DataState { idle, loading, data, empty, error }

class SearchProvider extends ChangeNotifier {
  DataState state = DataState.idle;
  String errorMessage = '';
  List<BookWorkModel> works = [];
  int page = 1;
  int limit = 20;
  int totalFound = 0;
  bool isLoadingMore = false;
  String currentQuery = '';

  // Perform search (with reset option for new queries)
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
      final fetched = result['works'] as List<BookWorkModel>;
      final found = result['numFound'] as int;

      if (fetched.isEmpty && page == 1) {
        state = DataState.empty;
      } else {
        works.addAll(fetched);
        totalFound = found;
        state = DataState.data;
      }
    } catch (e) {
      errorMessage = e.toString();
      state = DataState.error;
    }
    notifyListeners();
  }

  // Whether more results can be loaded
  bool get hasMore => works.length < totalFound;

  // Load next page of results
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore) return;
    isLoadingMore = true;
    page += 1;
    notifyListeners();
    try {
      final result = await BookRepository.search(currentQuery, page: page, limit: limit);
      final fetched = result['works'] as List<BookWorkModel>;
      works.addAll(fetched);
    } catch (e) {
      errorMessage = e.toString(); // keep error for debugging
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  // Reset provider state
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
