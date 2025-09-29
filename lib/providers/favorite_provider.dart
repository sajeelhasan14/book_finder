import 'dart:async';
import 'package:book_finder/services/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteProvider with ChangeNotifier {
  final FavoriteService _service = FavoriteService();
  List<Map<String, dynamic>> _favorites = [];
  StreamSubscription? _subscription;
  String? _uid;

  List<Map<String, dynamic>> get favorites => _favorites;

  /// Call this whenever auth changes (login/logout)
  void setUser(User? user) {
    _subscription?.cancel();
    _uid = user?.uid;

    if (_uid != null) {
      _listenToFavorites();
    } else {
      _favorites = [];
      notifyListeners();
    }
  }

  void _listenToFavorites() {
    _subscription = _service.getUserFavorites(_uid!).listen((data) {
      _favorites = data;
      notifyListeners();
    });
  }

  bool isFavorite(String key) {
    return _favorites.any((fav) => fav['key'] == key);
  }

  Future<void> toggleFavorite({
    required String key,
    required String title,
    int? coverId,
    List<String>? authors,
    int? firstPublishYear,
  }) async {
    if (_uid == null) return;

    if (isFavorite(key)) {
      await _service.removeFromFavorites(uid: _uid!, key: key);
    } else {
      // 🔥 Always ensure authors is saved as List<String>
      final safeAuthors = authors?.map((e) => e.toString()).toList();

      await _service.addToFavorites(
        uid: _uid!,
        key: key,
        title: title,
        coverId: coverId,
        authors: safeAuthors,
        firstPublishYear: firstPublishYear,
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
