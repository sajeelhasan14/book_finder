import 'package:book_finder/models/book_work.dart';

import 'package:flutter/material.dart';

import 'package:book_finder/repositories/book_repository.dart';

class BookProvider extends ChangeNotifier {
  // 🔥 Trending books
  List<BookWork> _trending = [];
  List<BookWork> get trending => _trending;



  bool _isLoadingTrending = false;
  bool get isLoadingTrending => _isLoadingTrending;

 

  String? _errorTrending;
  String? get errorTrending => _errorTrending;

 

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

 

  // Refresh both sections
  Future<void> refreshTrending() async {
    await Future.wait([
      fetchTrending(limit: 10),
      
    ]);
  }
}
