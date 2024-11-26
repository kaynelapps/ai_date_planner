import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:retry/retry.dart';
import 'package:soulplan_ai_fun_date_ideas/models/moment.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class MomentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isValidImageType(File image) {
    final validExtensions = ['.jpg', '.jpeg', '.png'];
    return validExtensions.any((ext) => image.path.toLowerCase().endsWith(ext));
  }

  Future<File> compressImage(File imageFile) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final fileName = 'compressed_${DateTime.now().millisecondsSinceEpoch}_${basename(imageFile.path)}';
    final targetPath = '$path/$fileName';

    var result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 1024,
      minHeight: 1024,
    );

    return File(result!.path);
  }


  Future<Map<String, String>> uploadImageWithThumbnail(File image) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/thumb_${basename(image.path)}';
    var thumbnail = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path, targetPath,
      quality: 50, minWidth: 300, minHeight: 300,
    );
    final String fullImageUrl = await uploadImage(image);
    final String thumbnailUrl = await uploadImage(File(thumbnail!.path));
    return {'fullImageUrl': fullImageUrl, 'thumbnailUrl': thumbnailUrl};
  }

  Future<String> uploadImage(File image) async {
    if (!_isValidImageType(image)) {
      throw CustomUploadException('Invalid image type. Only JPG and PNG are supported.');
    }
    try {
      final compressedImage = await compressImage(image);
      final String fileName = 'moment_${DateTime.now().millisecondsSinceEpoch}.${image.path.split('.').last}';
      final Reference ref = _storage.ref().child('moments/$fileName');
      final metadata = SettableMetadata(
        contentType: 'image/${image.path.endsWith('.jpg') || image.path.endsWith('.jpeg') ? 'jpeg' : 'png'}',
        customMetadata: {'timestamp': DateTime.now().toIso8601String()},
      );
      final uploadTask = await ref.putFile(compressedImage, metadata);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Upload error details: $e');
      throw CustomUploadException('Upload failed. Please check your connection and try again.');
    }
  }

  Future<String> createMoment(Moment moment) async {
    print('Creating moment with isPublic: ${moment.isPublic}');
    DocumentReference docRef = await _firestore.collection('moments').add({
      'imageUrl': moment.imageUrl,
      'description': moment.description,
      'isPublic': moment.isPublic,  // Ensure this is being set correctly
      'userEmail': moment.userEmail,
      'city': moment.city,
      'createdAt': moment.createdAt,
      'latitude': moment.latitude,
      'longitude': moment.longitude,
      'likes': [],
      'comments': [],
    });
    return docRef.id;
  }


  Future<void> deleteMoment(String momentId) async {
    try {
      // Get the moment document first
      final momentDoc = await _firestore.collection('moments').doc(momentId).get();

      if (momentDoc.exists) {
        final imageUrl = momentDoc.data()?['imageUrl'] as String?;

        // Delete the image from Firebase Storage
        if (imageUrl != null) {
          final ref = _storage.refFromURL(imageUrl);
          await ref.delete();
        }

        // Delete the Firestore document
        await _firestore.collection('moments').doc(momentId).delete();
      }
    } catch (e) {
      print('Error deleting moment: $e');
      throw CustomUploadException('Failed to delete moment and associated image');
    }
  }


  Future<List<Moment>> getUserMoments(String userEmail) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('moments')
        .where('userEmail', isEqualTo: userEmail)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => Moment.fromFirestore(doc)).toList();
  }

  Future<List<Moment>> getPublicMoments() async {
    print('Starting to fetch public moments from Firestore');
    return await retry(
          () async {
        QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('moments')
            .where('isPublic', isEqualTo: true)
            .orderBy('createdAt', descending: true)
            .limit(50)
            .get();

        final moments = snapshot.docs.map((doc) {
          print('Document data: ${doc.data()}');
          return Moment.fromFirestore(doc);
        }).toList();

        print('Successfully fetched ${moments.length} public moments');
        return moments;
      },
      retryIf: (e) => e is FirebaseException,
      maxAttempts: 3,
    );
  }


  Future<void> likeMoment(String momentId, String userEmail) async {
    DocumentReference momentRef = _firestore.collection('moments').doc(momentId);
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(momentRef);
      List<String> likes = List<String>.from(snapshot.get('likes') ?? []);
      likes.contains(userEmail) ? likes.remove(userEmail) : likes.add(userEmail);
      transaction.update(momentRef, {'likes': likes});
    });
  }

  Future<Comment> addComment(String momentId, String userEmail, String nickname, String text) async {
    final comment = Comment(
      id: '',
      userEmail: userEmail,
      nickname: nickname,
      text: text,
      createdAt: DateTime.now(),
    );
    final docRef = await _firestore.collection('moments').doc(momentId).collection('comments').add(comment.toMap());
    comment.id = docRef.id;
    return comment;
  }

  Future<List<Comment>> getComments(String momentId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('moments')
        .doc(momentId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => Comment.fromMap(doc.data())).toList();
  }
}

class CustomUploadException implements Exception {
  final String message;
  CustomUploadException(this.message);
  String toString() => 'CustomUploadException: $message';
}
