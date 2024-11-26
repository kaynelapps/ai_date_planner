import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:ui';
import '../models/moment.dart';
import '../widgets/user_avatar.dart';


class CommentWidget extends StatelessWidget {
  final Comment comment;
  final String momentId;
  final Function(String, String) onReply;

  const CommentWidget({
    Key? key,
    required this.comment,
    required this.momentId,
    required this.onReply,
  }) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    UserAvatar(email: comment.userEmail, radius: 16),
                    SizedBox(width: 8),
                    Text(
                      comment.nickname,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Text(
                      timeago.format(comment.createdAt),
                      style: GoogleFonts.poppins(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  comment.text,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => onReply(comment.id, comment.nickname),
                      child: Text(
                        'Reply',
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                if (comment.replies.isNotEmpty) ...[
                  SizedBox(height: 8),
                  ...comment.replies.map((reply) => _buildReply(reply)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReply(Reply reply) {
    return Padding(
      padding: EdgeInsets.only(left: 32, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(email: reply.userEmail, radius: 12),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reply.nickname,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  reply.text,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
