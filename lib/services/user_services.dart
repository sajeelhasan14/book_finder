import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // Save profile picture
  Future<String?> uploadProfilePic(File imageFile) async {
    try {
      final uid = _auth.currentUser!.uid;
      final ref = _storage.ref().child('profile_pics/$uid.jpg');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();

      await _firestore.collection('users').doc(uid).update({'photoUrl': url});

      return url;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final uid = _auth.currentUser!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}
