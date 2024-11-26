import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFFE91C40);
  static const headerGradient = LinearGradient(
    colors: [Color(0xFFFF6B95), Color(0xFFE91C40)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );
}