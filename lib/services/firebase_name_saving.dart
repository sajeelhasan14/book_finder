import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseNameSaving {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> saveName(String userName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await firestore.collection('users').doc(user.uid).set({
        'userName': userName,
      }, SetOptions(merge: true));
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  Future<Map<String, String>?> getName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        return {'userName': data['userName'] ?? ''};
      }
    }
    return null;
  }
}
