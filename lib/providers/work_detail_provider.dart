// lib/providers/work_detail_provider.dart

import 'package:flutter/material.dart';
import 'package:book_finder/models/book_work_model.dart';
import 'package:book_finder/repositories/book_repository.dart';

// States for handling work detail loading
enum WorkDetailState { idle, loading, data, error }

class WorkDetailProvider extends ChangeNotifier {
  WorkDetailState state = WorkDetailState.idle;
  String? errorMessage;
  BookWorkModel? work;

  // Load detailed info for a work
  Future<void> loadWork(String workId) async {
    state = WorkDetailState.loading;
    errorMessage = null;
    work = null;
    notifyListeners();

    try {
      work = await BookRepository.getWork(workId);
      state = WorkDetailState.data;
    } catch (e) {
      errorMessage = e.toString();
      state = WorkDetailState.error;
    }
    notifyListeners();
  }

  // Reset provider state
  void clear() {
    state = WorkDetailState.idle;
    errorMessage = null;
    work = null;
    notifyListeners();
  }
}
