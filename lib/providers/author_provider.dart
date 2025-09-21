// lib/providers/author_provider.dart
import 'package:flutter/material.dart';
import 'package:book_finder/models/author.dart';
import 'package:book_finder/repositories/author_repository.dart';
import 'package:book_finder/models/book_work.dart';

/// States for AuthorProvider
enum AuthorState { idle, loading, data, error }

/// Manages loading author details and their works
class AuthorProvider extends ChangeNotifier {
  AuthorState state = AuthorState.idle;
  String? errorMessage;
  AuthorModel? author;
  List<BookWork> works = [];

  /// Load author info and works by ID
  Future<void> loadAuthor(String authorId) async {
    state = AuthorState.loading;
    errorMessage = null;
    author = null;
    works = [];
    notifyListeners();

    try {
      author = await AuthorRepository.getAuthor(authorId);     // fetch author
      works = await AuthorRepository.getAuthorWorks(authorId); // fetch works
      state = AuthorState.data;
    } catch (e) {
      errorMessage = e.toString();
      state = AuthorState.error;
    }
    notifyListeners();
  }
}
