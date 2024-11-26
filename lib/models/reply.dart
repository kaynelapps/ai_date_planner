class Reply {
  final String id;
  final String userEmail;
  final String nickname;
  final String text;
  final DateTime createdAt;

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
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      id: map['id'],
      userEmail: map['userEmail'],
      nickname: map['nickname'],
      text: map['text'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
