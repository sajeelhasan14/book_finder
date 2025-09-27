import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream all favorites of current user
  Stream<List<Map<String, dynamic>>> getUserFavorites(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Add to favorites
  Future<void> addToFavorites({
    required String uid,
    required String key,
    required String title,
    int? coverId,
    List<String>? authors,
    int? firstPublishYear,
  }) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .doc(key)
        .set({
      "key": key,
      "title": title,
      "coverId": coverId,
      "authors": authors,
      "firstPublishYear": firstPublishYear,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// Remove from favorites
  Future<void> removeFromFavorites({required String uid, required String key}) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .doc(key)
        .delete();
  }
}
