// lib/providers/work_detail_provider.dart
import 'package:flutter/material.dart';
import 'package:book_finder/models/book_work_model.dart';
import 'package:book_finder/repositories/book_repository.dart';

// 📌 Enum to represent the state of work detail data
enum WorkDetailState { idle, loading, data, error }

class WorkDetailProvider extends ChangeNotifier {
  // Current state
  WorkDetailState state = WorkDetailState.idle;

  // Error message if something goes wrong
  String? errorMessage;

  // Work details (book info)
  BookWorkModel? work;

  // 🔎 Load details of a specific work by ID
  Future<void> loadWork(String workId) async {
    state = WorkDetailState.loading;
    errorMessage = null;
    work = null;
    notifyListeners();

    try {
      // Fetch work detail from repository
      work = await BookRepository.getWork(workId);
      state = WorkDetailState.data;
    } catch (e) {
      // Handle error state
      errorMessage = e.toString();
      state = WorkDetailState.error;
    }

    notifyListeners();
  }

  // 🧹 Reset provider state
  void clear() {
    state = WorkDetailState.idle;
    errorMessage = null;
    work = null;
    notifyListeners();
  }
}
