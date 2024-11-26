import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/moment.dart';
import '../providers/moment_provider.dart';
import '../services/auth_service.dart';

class LikeButton extends StatelessWidget {
  final Moment moment;

  const LikeButton({required this.moment});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return FutureBuilder<String?>(
          future: authService.getCurrentUserEmail(),
          builder: (context, snapshot) {
            final userEmail = snapshot.data;
            final isLiked = moment.likes.contains(userEmail);

            return Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Color(0xFFE91C40) : Colors.black87,
                  ),
                  onPressed: () {
                    if (userEmail != null) {
                      Provider.of<MomentProvider>(context, listen: false)
                          .likeMoment(moment.id, userEmail);
                    }
                  },
                ),
                Text(
                  '${moment.likes.length}',
                  style: GoogleFonts.poppins(color: Colors.black87),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
