import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserAvatar extends StatelessWidget {
  final String email;
  final double radius;

  const UserAvatar({
    Key? key,
    required this.email,
    this.radius = 20,
  }) : super(key: key);

  String getAvatarUrl(String email) {
    final hash = md5.convert(utf8.encode(email.trim().toLowerCase())).toString();
    return 'https://api.dicebear.com/6.x/croodles/png?seed=$hash&backgroundColor=b91c1c,991b1b,7f1d1d&radius=50';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CachedNetworkImage(
        imageUrl: getAvatarUrl(email),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black12,
          ),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91C40)),
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black12,
          ),
          child: const Icon(Icons.person, color: Color(0xFFE91C40)),
        ),
      ),
    );
  }
}
