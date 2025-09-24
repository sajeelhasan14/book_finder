// lib/providers/favorites_provider.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:book_finder/repositories/favorites_repository.dart';
import 'package:book_finder/providers/auth_provider.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepository _repo = FavoritesRepository(); // Repo to interact with Firestore
  List<Map<String, dynamic>> favorites = [];               // Local cache of favorites
  String? uid;                                             // Current signed-in user ID
    StreamSubscription<List<Map<String, dynamic>>>? subscription;                                  // Firestore subscription

  // Called when authentication changes (login/logout)
  void updateForAuth(AuthProvider auth) {
    if (auth.user == null) {
      // User logged out → clear local favorites
      favorites = [];
      uid = null;
      notifyListeners();
    } else {
      // User logged in → start listening to Firestore favorites
      uid = auth.user!.uid;
      subscription = _repo.streamFavorites(uid!).listen((list) {
        favorites = list;  // Update local list whenever Firestore changes
        notifyListeners(); // Notify UI
      });
    }
  }

  // Add a book to favorites
  Future<void> addFavorite(Map<String, dynamic> payload) async {
    if (uid == null) throw Exception('Not signed in');
    // Store timestamp when added
    payload['addedAt'] = DateTime.now().toIso8601String();
    await _repo.addFavorite(uid!, payload);
  }

  // Remove a book from favorites
  Future<void> removeFavorite(String workKey) async {
    if (uid == null) throw Exception('Not signed in');
    await _repo.removeFavorite(uid!, workKey);
  }
}
