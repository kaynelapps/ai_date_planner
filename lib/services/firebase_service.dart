import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class FirebaseService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initializeApp() async {
    await Firebase.initializeApp();
  }

  static Future<String> uploadImage(String path, String userId) async {
    final ref = _storage.ref().child('challenge_images/$userId/${DateTime.now()}.jpg');
    final uploadTask = await ref.putFile(File(path));
    return await uploadTask.ref.getDownloadURL();
  }

  static Future<void> saveCompletedChallenge({
    required String userId,
    required String title,
    required String imageUrl,
    required String description,
  }) async {
    await _firestore.collection('completedChallenges').add({
      'userId': userId,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'completedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getCompletedChallenges(String userId) {
    return _firestore
        .collection('completedChallenges')
        .where('userId', isEqualTo: userId)
        .orderBy('completedAt', descending: true)
        .snapshots();
  }
}
