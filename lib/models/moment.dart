import 'package:cloud_firestore/cloud_firestore.dart';

class Moment {
  String id;
  String imageUrl;
  String description;
  bool isPublic;
  String userEmail;
  String city;
  DateTime createdAt;
  List<String> likes;
  List<Comment> comments;
  double latitude;
  double longitude;

  Moment({
    required this.id,
    required this.imageUrl,
    required this.description,
    required this.isPublic,
    required this.userEmail,
    required this.city,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    List<String>? likes,
    List<Comment>? comments,
  }) :
        this.likes = likes ?? [],
        this.comments = comments ?? [];

  Moment copyWith({
    String? id,
    String? imageUrl,
    String? description,
    bool? isPublic,
    String? userEmail,
    String? city,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
    List<String>? likes,
    List<Comment>? comments,
  }) {
    return Moment(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isPublic: isPublic ?? this.isPublic,
      userEmail: userEmail ?? this.userEmail,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      likes: likes ?? List.from(this.likes),
      comments: comments ?? List.from(this.comments),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'description': description,
      'isPublic': isPublic,
      'userEmail': userEmail,
      'city': city,
      'createdAt': Timestamp.fromDate(createdAt),
      'latitude': latitude,
      'longitude': longitude,
      'likes': likes,
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }

  factory Moment.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Moment(
      id: doc.id,
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      isPublic: data['isPublic'] ?? false,
      userEmail: data['userEmail'] ?? '',
      city: data['city'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      likes: List<String>.from(data['likes'] ?? []),
      comments: (data['comments'] as List<dynamic>? ?? [])
          .map((c) => Comment.fromMap(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Comment {
  String id;
  String userEmail;
  String nickname;
  String text;
  DateTime createdAt;
  List<String> likes;
  List<Reply> replies;

  Comment({
    required this.id,
    required this.userEmail,
    required this.nickname,
    required this.text,
    required this.createdAt,
    List<String>? likes,
    List<Reply>? replies,
  }) :
        this.likes = likes ?? [],
        this.replies = replies ?? [];

  Comment copyWith({
    String? id,
    String? userEmail,
    String? nickname,
    String? text,
    DateTime? createdAt,
    List<String>? likes,
    List<Reply>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      userEmail: userEmail ?? this.userEmail,
      nickname: nickname ?? this.nickname,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? List.from(this.likes),
      replies: replies ?? List.from(this.replies),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userEmail': userEmail,
      'nickname': nickname,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
      'replies': replies.map((r) => r.toMap()).toList(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      userEmail: map['userEmail'] ?? '',
      nickname: map['nickname'] ?? '',
      text: map['text'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      likes: List<String>.from(map['likes'] ?? []),
      replies: (map['replies'] as List<dynamic>? ?? [])
          .map((r) => Reply.fromMap(r as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Reply {
  String id;
  String userEmail;
  String nickname;
  String text;
  DateTime createdAt;

  Reply({
    required this.id,
    required this.userEmail,
    required this.nickname,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userEmail': userEmail,
      'nickname': nickname,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      id: map['id'] ?? '',
      userEmail: map['userEmail'] ?? '',
      nickname: map['nickname'] ?? '',
      text: map['text'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
