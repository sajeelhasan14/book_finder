// lib/repositories/favorites_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to a user's favorites sub-collection
  CollectionReference<Map<String, dynamic>> _favoritesRef(String uid) =>
      _firestore.collection('users').doc(uid).collection('favorites');

  // Add a book to favorites
  Future<void> addFavorite(String uid, Map<String, dynamic> payload) async {
    final key = payload['work_key'] ?? payload['key'];
    if (key == null) throw Exception('Missing key for favorite');
    await _favoritesRef(uid).doc(key.toString()).set(payload);
  }

  // Remove a book from favorites
  Future<void> removeFavorite(String uid, String workKey) async {
    await _favoritesRef(uid).doc(workKey).delete();
  }

  // Stream favorites in real-time (ordered by addedAt)
  Stream<List<Map<String, dynamic>>> streamFavorites(String uid) {
    return _favoritesRef(uid)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }
}
