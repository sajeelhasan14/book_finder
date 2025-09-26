import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:book_finder/models/book_work.dart';
import 'package:book_finder/repositories/book_repository.dart';

enum FilterType { all, title, author, isbn }

class SearchProvider with ChangeNotifier {
  String _query = '';
  FilterType _filter = FilterType.all;
  List<BookWork> _results = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  Timer? _debounce;

  // Getters
  String get query => _query;
  FilterType get filter => _filter;
  List<BookWork> get results => _results;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  // Update search query with debounce
  void updateQuery(String value) {
    _query = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _resetAndSearch();
    });
    notifyListeners();
  }

  void updateFilter(FilterType f) {
    _filter = f;
    _resetAndSearch();
  }

  Future<void> _resetAndSearch() async {
    _results = [];
    _page = 1;
    _hasMore = true;
    notifyListeners();
    if (_query.isNotEmpty) {
      await fetchBooks();
    }
  }

  Future<void> fetchBooks() async {
    if (_isLoading || !_hasMore || _query.isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final resp = await BookRepository.search(_query, page: _page, limit: 20);
      final works = resp['works'] as List<BookWork>;
      final numFound = resp['numFound'] as int;

      if (_page == 1) {
        _results = works;
      } else {
        _results.addAll(works);
      }

      _hasMore = _results.length < numFound;
      _page++;
    } catch (e) {
      _error = 'An error occurred while searching. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }

  void retry() {
    _resetAndSearch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
