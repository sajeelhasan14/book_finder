import 'package:flutter/material.dart';
import 'package:book_finder/models/book_work.dart';
import 'package:book_finder/repositories/book_repository.dart';

class BookProvider extends ChangeNotifier {
  // 🔥 Trending books
  List<BookWork> _trending = [];
  List<BookWork> get trending => _trending;

  // 🆕 Recently added books
  List<BookWork> _recent = [];
  List<BookWork> get recent => _recent;

  bool _isLoadingTrending = false;
  bool get isLoadingTrending => _isLoadingTrending;

  bool _isLoadingRecent = false;
  bool get isLoadingRecent => _isLoadingRecent;

  String? _errorTrending;
  String? get errorTrending => _errorTrending;

  String? _errorRecent;
  String? get errorRecent => _errorRecent;

  // Fetch trending books
  Future<void> fetchTrending({int limit = 10}) async {
    _isLoadingTrending = true;
    _errorTrending = null;
    notifyListeners();

    try {
      final books = await BookRepository.getTrendingBooks(limit: limit);
      _trending = books;
    } catch (e) {
      _errorTrending = e.toString();
    }

    _isLoadingTrending = false;
    notifyListeners();
  }

  // Fetch recently added books
  Future<void> fetchRecent({int limit = 10}) async {
    _isLoadingRecent = true;
    _errorRecent = null;
    notifyListeners();

    try {
      final books = await BookRepository.getRecentBooks(limit: limit);
      _recent = books;
    } catch (e) {
      _errorRecent = e.toString();
    }

    _isLoadingRecent = false;
    notifyListeners();
  }

  // Refresh both sections
  Future<void> refreshAll() async {
    await Future.wait([
      fetchTrending(limit: 10),
      fetchRecent(limit: 10),
    ]);
  }
}
