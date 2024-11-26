import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soulplan_ai_fun_date_ideas/models/moment.dart';
import 'package:soulplan_ai_fun_date_ideas/services/moment_service.dart';
import 'package:soulplan_ai_fun_date_ideas/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:soulplan_ai_fun_date_ideas/services/auth_service.dart';

class MomentProvider with ChangeNotifier {
  final MomentService _momentService = MomentService();
  final LocationService _locationService = LocationService();

  List<Moment> _userMoments = [];
  List<Moment> _publicMoments = [];
  String? _error;

  List<Moment> get userMoments => _userMoments;
  List<Moment> get publicMoments => _publicMoments;
  String? get error => _error;

  void _setError(String errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> createMoment(File image, String description, bool isPublic, String email, double latitude, double longitude) async {
    try {
      String imageUrl = await _momentService.uploadImage(image);

      final moment = Moment(
        id: '',
        imageUrl: imageUrl,
        description: description,
        isPublic: isPublic,
        userEmail: email,
        city: await _locationService.getCurrentCity(),
        createdAt: DateTime.now(),
        latitude: latitude,
        longitude: longitude,
      );

      String momentId = await _momentService.createMoment(moment);
      moment.id = momentId;

      // Update local lists immediately
      _userMoments.insert(0, moment);
      if (isPublic) {
        _publicMoments.insert(0, moment);
      }
      notifyListeners();
    } catch (e) {
      throw CustomUploadException('Failed to upload image: $e');
    }
  }


  Future<void> addReplyToComment(String momentId, String commentId, Reply reply) async {
    try {
      final momentDoc = FirebaseFirestore.instance.collection('moments').doc(momentId);
      final momentSnapshot = await momentDoc.get();
      final moment = Moment.fromFirestore(momentSnapshot);

      final commentIndex = moment.comments.indexWhere((c) => c.id == commentId);
      if (commentIndex == -1) return;

      final updatedComments = List<Comment>.from(moment.comments);
      updatedComments[commentIndex].replies.add(reply);

      await momentDoc.update({
        'comments': updatedComments.map((c) => c.toMap()).toList(),
      });

      _updateMomentReplies(momentId, commentId, reply);
      notifyListeners();
    } catch (e) {
      print('Error adding reply to comment: $e');
    }
  }
  Future<void> addReply(String momentId, String commentId, String userEmail, String nickname, String text) async {
    try {
      final reply = Reply(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userEmail: userEmail,
        nickname: nickname,
        text: text,
        createdAt: DateTime.now(),
      );

      await addReplyToComment(momentId, commentId, reply);
      notifyListeners();
    } catch (e) {
      print('Error adding reply: $e');
    }
  }


  void _updateMomentReplies(String momentId, String commentId, Reply reply) {
    void updateReplies(List<Moment> moments) {
      for (var i = 0; i < moments.length; i++) {
        if (moments[i].id == momentId) {
          final commentIndex = moments[i].comments.indexWhere((c) => c.id == commentId);
          if (commentIndex != -1) {
            moments[i].comments[commentIndex].replies.add(reply);
          }
          break;
        }
      }
    }

    updateReplies(_userMoments);
    updateReplies(_publicMoments);
  }


  Future<void> deleteMoment(String momentId) async {
    try {
      await _momentService.deleteMoment(momentId);
      _userMoments.removeWhere((moment) => moment.id == momentId);
      _publicMoments.removeWhere((moment) => moment.id == momentId);
      notifyListeners();
    } catch (e) {
      print('Error deleting moment: $e');
    }
  }

  Future<void> fetchUserMoments(String userEmail) async {
    try {
      _userMoments = await _momentService.getUserMoments(userEmail);
      clearError();
    } catch (e) {
      print('Error fetching user moments: $e');
      _userMoments = [];
      _setError('Failed to fetch user moments. Please try again.');
    }
    notifyListeners();
  }

  Future<void> deleteComment(String momentId, String commentId) async {
    try {
      final momentDoc = FirebaseFirestore.instance.collection('moments').doc(momentId);
      final momentSnapshot = await momentDoc.get();
      final moment = Moment.fromFirestore(momentSnapshot);

      final updatedComments = moment.comments.where((c) => c.id != commentId).toList();

      await momentDoc.update({
        'comments': updatedComments.map((c) => c.toMap()).toList(),
      });

      _updateMomentsAfterCommentDeletion(momentId, commentId);
      notifyListeners();
    } catch (e) {
      print('Error deleting comment: $e');
    }
  }

  void _updateMomentsAfterCommentDeletion(String momentId, String commentId) {
    void updateComments(List<Moment> moments) {
      for (var i = 0; i < moments.length; i++) {
        if (moments[i].id == momentId) {
          final updatedComments = moments[i].comments.where((c) => c.id != commentId).toList();
          moments[i] = moments[i].copyWith(comments: updatedComments);
          break;
        }
      }
    }

    updateComments(_userMoments);
    updateComments(_publicMoments);
  }


  Future<void> fetchPublicMoments() async {
    try {
      print('Fetching public moments...');
      _publicMoments = await _momentService.getPublicMoments();

      // Filter valid image URLs
      _publicMoments = _publicMoments.where((moment) {
        final uri = Uri.tryParse(moment.imageUrl);
        final path = uri?.path.toLowerCase() ?? '';
        return uri != null &&
            uri.hasAbsolutePath &&
            (path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png'));
      }).toList();

      print('Fetched ${_publicMoments.length} valid public moments');
      clearError();
    } catch (e) {
      print('Error fetching public moments: $e');
      _publicMoments = [];
      _setError('Failed to fetch public moments. Please try again.');
    }
    notifyListeners();
  }



  Future<void> likeMoment(String momentId, String userEmail) async {
    try {
      await _momentService.likeMoment(momentId, userEmail);
      _updateMomentLikes(momentId, userEmail);
      notifyListeners();
    } catch (e) {
      print('Error liking moment: $e');
    }
  }

  void _updateMomentLikes(String momentId, String userEmail) {
    void updateLikes(List<Moment> moments) {
      for (var i = 0; i < moments.length; i++) {
        if (moments[i].id == momentId) {
          List<String> updatedLikes = List.from(moments[i].likes);
          if (updatedLikes.contains(userEmail)) {
            updatedLikes.remove(userEmail);
          } else {
            updatedLikes.add(userEmail);
          }
          moments[i] = moments[i].copyWith(likes: updatedLikes);
          break;
        }
      }
    }

    updateLikes(_userMoments);
    updateLikes(_publicMoments);
  }

  Future<void> addComment(String momentId, String userEmail, String nickname, String text) async {
    try {
      final comment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userEmail: userEmail,
        nickname: nickname,
        text: text,
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('moments').doc(momentId).update({
        'comments': FieldValue.arrayUnion([comment.toMap()]),
      });

      _updateMomentComments(momentId, comment);
      notifyListeners();
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  void _updateMomentComments(String momentId, Comment comment) {
    void updateComments(List<Moment> moments) {
      for (var i = 0; i < moments.length; i++) {
        if (moments[i].id == momentId) {
          List<Comment> updatedComments = List.from(moments[i].comments)..add(comment);
          moments[i] = moments[i].copyWith(comments: updatedComments);
          break;
        }
      }
    }

    updateComments(_userMoments);
    updateComments(_publicMoments);
  }

  Moment? getMomentById(String id) {
    return _userMoments.firstWhere((moment) => moment.id == id,
        orElse: () => _publicMoments.firstWhere((moment) => moment.id == id,
            orElse: () => throw Exception('Moment not found')));
  }

  List<Moment> getNearbyMoments(double latitude, double longitude, double radiusInKm) {
    return _publicMoments.where((moment) {
      double distance = _calculateDistance(latitude, longitude, moment.latitude, moment.longitude);
      return distance <= radiusInKm;
    }).toList();
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  Future<void> likeComment(String momentId, String commentId) async {
    try {
      final userEmail = await AuthService().getCurrentUserEmail();
      if (userEmail == null) return;

      final momentDoc = FirebaseFirestore.instance.collection('moments').doc(momentId);
      final momentSnapshot = await momentDoc.get();
      final moment = Moment.fromFirestore(momentSnapshot);

      final commentIndex = moment.comments.indexWhere((c) => c.id == commentId);
      if (commentIndex == -1) return;

      final comment = moment.comments[commentIndex];
      final updatedLikes = List<String>.from(comment.likes);

      if (updatedLikes.contains(userEmail)) {
        updatedLikes.remove(userEmail);
      } else {
        updatedLikes.add(userEmail);
      }

      await momentDoc.update({
        'comments': moment.comments.map((c) {
          if (c.id == commentId) {
            return {...c.toMap(), 'likes': updatedLikes};
          }
          return c.toMap();
        }).toList(),
      });

      _updateCommentLikes(momentId, commentId, updatedLikes);
      notifyListeners();
    } catch (e) {
      print('Error liking comment: $e');
    }
  }

  void _updateCommentLikes(String momentId, String commentId, List<String> updatedLikes) {
    void updateLikes(List<Moment> moments) {
      for (var i = 0; i < moments.length; i++) {
        if (moments[i].id == momentId) {
          final commentIndex = moments[i].comments.indexWhere((c) => c.id == commentId);
          if (commentIndex != -1) {
            moments[i].comments[commentIndex] = moments[i].comments[commentIndex].copyWith(likes: updatedLikes);
          }
          break;
        }
      }
    }

    updateLikes(_userMoments);
    updateLikes(_publicMoments);
  }
}
