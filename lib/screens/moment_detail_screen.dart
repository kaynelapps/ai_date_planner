import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';
import '../widgets/like_button.dart';
import '../providers/moment_provider.dart';
import '../services/auth_service.dart';
import '../models/moment.dart';
import '../widgets/glass_button.dart';
import '../widgets/user_avatar.dart';
import '../widgets/comment_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

class MomentDetailScreen extends StatefulWidget {
  final String momentId;
  final bool isUserMoment;

  const MomentDetailScreen({
    required this.momentId,
    required this.isUserMoment,
    Key? key,
  }) : super(key: key);

  @override
  _MomentDetailScreenState createState() => _MomentDetailScreenState();
}
class _MomentDetailScreenState extends State<MomentDetailScreen> {
  bool _isLoading = true;
  String? replyToCommentId;
  String? replyToUsername;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // The moment will be automatically fetched through getMomentById in the build method
      await Future.delayed(Duration(milliseconds: 100)); // Optional: Add a small delay for loading state
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomSheet: CommentInput(
        momentId: widget.momentId,
        onCommentAdded: _loadData,
        replyToCommentId: replyToCommentId,
        replyToUsername: replyToUsername,
      ),

    );
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        AppLocalizations.of(context)!.momentsTitle,
        style: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        // Delete button for all moments
        IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.black),
          onPressed: () => _showDeleteDialog(),
        ),
        // Flag button for non-user moments
        IconButton(
          icon: Icon(Icons.flag_outlined, color: Colors.black),
          onPressed: () => _showFlagDialog(),
        ),
        // Share button for all moments
        IconButton(
          icon: Icon(Icons.share_outlined, color: Colors.black),
          onPressed: () => Share.share('Check out this moment!'),
        ),
      ],
    );
  }





  void _showFlagDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Report Content',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFlagOption('Inappropriate Content'),
            _buildFlagOption('Spam'),
            _buildFlagOption('Violence'),
            _buildFlagOption('Other'),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagOption(String reason) {
    return ListTile(
      title: Text(
        reason,
        style: GoogleFonts.poppins(color: Colors.black87),
      ),
      onTap: () {
        // Implement flag functionality
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Content reported successfully')),
        );
      },
    );
  }

  Widget _buildBody() {
    return Consumer<MomentProvider>(
      builder: (context, provider, child) {
        final moment = provider.getMomentById(widget.momentId);

        if (_isLoading) {
          return _buildLoadingState();
        }

        if (moment == null) {
          return _buildErrorState();
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainImage(moment),
              _buildInteractionBar(moment),
              _buildDescription(moment),
              _buildComments(moment),
            ].animate(interval: 100.ms).fadeIn().slideY(),
          ),
        );
      },
    );
  }

  Widget _buildMainImage(Moment moment) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 1,
          child: CachedNetworkImage(
            imageUrl: moment.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91C40)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionBar(Moment moment) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            LikeButton(moment: moment),
            SizedBox(width: 24),
            Icon(Icons.comment_outlined, color: Colors.black),
            SizedBox(width: 8),
            Text(
              '${moment.comments.length}',
              style: GoogleFonts.poppins(color: Colors.black),
            ),
            Spacer(),
            UserAvatar(email: moment.userEmail, radius: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(Moment moment) {
    if (moment.description.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Text(
          moment.description,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildComments(Moment moment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Comments',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        ...moment.comments.map((comment) => _buildCommentItem(comment)).toList(),
        SizedBox(height: 100), // Space for CommentInput
      ],
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(email: comment.userEmail, radius: 20),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.nickname,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      timeago.format(comment.createdAt),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<String?>(
                future: AuthService().getCurrentUserEmail(),
                builder: (context, snapshot) {
                  if (snapshot.data == comment.userEmail) {
                    return IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.grey[600]),
                      onPressed: () => Provider.of<MomentProvider>(context, listen: false)
                          .deleteComment(widget.momentId, comment.id),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            comment.text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildCommentLikeButton(comment),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    replyToCommentId = comment.id;
                    replyToUsername = comment.nickname;
                  });
                  // Scroll to comment input
                  Scrollable.ensureVisible(
                    context,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.reply, size: 20, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      'Reply',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comment.replies.isNotEmpty) ...[
            SizedBox(height: 12),
            ...comment.replies.map((reply) => _buildReplyItem(reply)).toList(),
          ],
        ],
      ),
    );
  }

  void _deleteComment(String commentId) {
    Provider.of<MomentProvider>(context, listen: false)
        .deleteComment(widget.momentId, commentId);
  }

  void _handleReply(String commentId, String nickname) {
    setState(() {
      replyToCommentId = commentId;
      replyToUsername = nickname;
    });

    // Scroll to comment input
    Scrollable.ensureVisible(
      context,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildCommentLikeButton(Comment comment) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return FutureBuilder<String?>(
          future: authService.getCurrentUserEmail(),
          builder: (context, snapshot) {
            final userEmail = snapshot.data;
            final isLiked = comment.likes.contains(userEmail);

            return GestureDetector(
              onTap: () {
                if (userEmail != null) {
                  Provider.of<MomentProvider>(context, listen: false)
                      .likeComment(widget.momentId, comment.id);
                }
              },
              child: Row(
                children: [
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isLiked ? Color(0xFFE91C40) : Colors.grey[600],
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${comment.likes.length}',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReplyItem(Reply reply) {
    return Container(
      margin: EdgeInsets.only(left: 32, top: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(email: reply.userEmail, radius: 16),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reply.nickname,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  reply.text,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91C40)),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.momentNotFound,
        style: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          AppLocalizations.of(context)!.deleteMomentTitle,
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.deleteMomentMessage,
          style: GoogleFonts.poppins(color: Colors.black87),
        ),
        actions: [
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.cancelButton,
              style: GoogleFonts.poppins(color: Colors.black87),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.deleteMomentTitle,
              style: GoogleFonts.poppins(color: Color(0xFFE91C40)),
            ),
            onPressed: () {
              Provider.of<MomentProvider>(context, listen: false)
                  .deleteMoment(widget.momentId);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
