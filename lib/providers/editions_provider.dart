// lib/providers/editions_provider.dart

import 'package:flutter/material.dart';
import 'package:book_finder/models/edition.dart';
import 'package:book_finder/repositories/book_repository.dart';

// States for handling editions loading
enum EditionsState { idle, loading, data, error, empty }

class EditionsProvider extends ChangeNotifier {
  EditionsState state = EditionsState.idle;
  String? errorMessage;
  List<Edition> editions = [];
  int limit = 20;
  int offset = 0;
  bool isLoadingMore = false;

  // Load editions for a work (reset = true for first load)
  Future<void> loadEditions(String workId, {bool reset = true}) async {
    if (reset) {
      state = EditionsState.loading;
      editions = [];
      offset = 0;
      notifyListeners();
    }
    try {
      final fetched = await BookRepository.getEditions(workId, limit: limit, offset: offset);
      if (fetched.isEmpty && offset == 0) {
        state = EditionsState.empty;
      } else {
        editions.addAll(fetched);
        state = EditionsState.data;
        offset += fetched.length;
      }
    } catch (e) {
      errorMessage = e.toString();
      state = EditionsState.error;
    }
    notifyListeners();
  }

  // Load more editions (pagination)
  Future<void> loadMore(String workId) async {
    if (isLoadingMore) return;
    isLoadingMore = true;
    notifyListeners();
    try {
      final fetched = await BookRepository.getEditions(workId, limit: limit, offset: offset);
      editions.addAll(fetched);
      offset += fetched.length;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}
