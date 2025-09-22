// lib/providers/favorites_provider.dart
import 'package:flutter/material.dart';
import 'package:book_finder/repositories/favorites_repository.dart';
import 'package:book_finder/providers/auth_provider.dart';

/// Provider to manage user's favorite books
class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepository _repo = FavoritesRepository();
  List<Map<String, dynamic>> favorites = [];
  String? uid;
  Stream? _subscription;

  /// Update favorites when auth state changes
  void updateForAuth(AuthProvider auth) {
    if (auth.user == null) {
      favorites = [];
      uid = null;
      notifyListeners();
    } else {
      uid = auth.user!.uid;
      // Start listening to favorites stream
      _subscription = _repo.streamFavorites(uid!).listen((list) {
        favorites = list;
        notifyListeners();
      }) as Stream?;
    }
  }

  /// Add a book to favorites
  Future<void> addFavorite(Map<String, dynamic> payload) async {
    if (uid == null) throw Exception('Not signed in');
    payload['addedAt'] = DateTime.now().toIso8601String();
    await _repo.addFavorite(uid!, payload);
  }

  /// Remove a book from favorites
  Future<void> removeFavorite(String workKey) async {
    if (uid == null) throw Exception('Not signed in');
    await _repo.removeFavorite(uid!, workKey);
  }
}
