import 'package:book_finder/models/book_work.dart';
import 'package:book_finder/models/book_work_model.dart';

import 'package:flutter/material.dart';

import 'package:book_finder/repositories/book_repository.dart';

class BookProvider extends ChangeNotifier {
  // 🔥 Trending books
  List<BookWork> _trending = [];
  List<BookWork> get trending => _trending;

  BookWorkModel? _detailData;
  BookWorkModel? get detailData => _detailData;

  
  

  bool _isLoadingDetail = false;
  bool get isLoadingDetail => _isLoadingDetail;

  String? _errorDetail;
  String? get errorDetail => _errorDetail;

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

   // Fetch work detail by key
  Future<void> fetchDetailData({required String workId}) async {
    _isLoadingDetail = true;
    _errorDetail = null;
    notifyListeners();

    try {
      final data = await BookRepository.getWork(workId);
      _detailData = data; // single work
    } catch (e) {
      _errorDetail = e.toString();
      _detailData = null;
    }

    _isLoadingDetail = false;
    notifyListeners();
  }
  
}
