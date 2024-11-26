import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/moment_provider.dart';
import '../services/auth_service.dart';
import 'glass_button.dart';
import '../models/moment.dart';


class CommentInput extends StatefulWidget {
  final String momentId;
  final Function onCommentAdded;
  final String? replyToCommentId;
  final String? replyToUsername;

  const CommentInput({
    required this.momentId,
    required this.onCommentAdded,
    this.replyToCommentId,
    this.replyToUsername,
    Key? key,
  }) : super(key: key);

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _commentController = TextEditingController();

 Future<void> _submitComment() async {
  if (_commentController.text.trim().isEmpty) return;
  
  final currentContext = context;
  final userEmail = await AuthService().getCurrentUserEmail();
  final nickname = await AuthService().getCurrentUserNickname();

  if (userEmail != null && nickname != null && mounted) {
    if (widget.replyToCommentId != null) {
      await Provider.of<MomentProvider>(currentContext, listen: false).addReply(
        widget.momentId,
        widget.replyToCommentId!,
        userEmail,
        nickname,
        _commentController.text,
      );
    } else {
      await Provider.of<MomentProvider>(currentContext, listen: false).addComment(
        widget.momentId,
        userEmail,
        nickname,
        _commentController.text,
      );
    }
    
    _commentController.clear();
    widget.onCommentAdded();
  }
}

@override
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Colors.grey[200]!)),
    ),
    child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.replyToUsername != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    'Replying to ${widget.replyToUsername}',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => widget.onCommentAdded(),
                    child: Icon(Icons.close, size: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: widget.replyToUsername != null
                        ? 'Write a reply...'
                        : 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFFE91C40)),
                onPressed: _submitComment,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
