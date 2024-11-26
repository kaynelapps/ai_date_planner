import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Colors
  static const Color kMainColor = Color(0xFFE91C40);  // A vibrant pink
  static const Color kSecondaryColor = Color(0xFFFFF6F8);  // A deep blue

  // Background Colors
  static const Color kBgColor = Color(0xFFFFF6F8);  // Light pink background
  static const Color kDarkWhite = Color(0xFFF8F9FA);  // Off-white for cards

  // Text Colors
  static const Color kTitleColor = Color(0xFF2C3E50);  // Dark blue for titles
  static const Color kGreyTextColor = Color(0xFF7F8C8D);  // Subtle grey for secondary text

  // Accent Colors
  static const Color kAlertColor = Color(0xFFFF9800);  // Orange for alerts/warnings
  static const Color kGreenColor = Color(0xFF2ECC71);  // Green for success/positive actions

  // UI Element Colors
  static const Color kBorderColorTextField = Color(0xFFE0E0E0);  // Light grey for borders
}

// Typography
final kTextStyle = GoogleFonts.poppins(
  color: AppColors.kTitleColor,
);

// Common Decorations
const kButtonDecoration = BoxDecoration(
  color: AppColors.kMainColor,
  borderRadius: BorderRadius.all(Radius.circular(10)),
  boxShadow: [
    BoxShadow(
      color: Color(0x29000000),
      offset: Offset(0, 4),
      blurRadius: 3,
    ),
  ],
);

final kInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: AppColors.kGreyTextColor),
  filled: true,
  fillColor: AppColors.kDarkWhite,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(color: AppColors.kBorderColorTextField, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(color: AppColors.kMainColor, width: 2),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: BorderSide(color: AppColors.kMainColor.withOpacity(0.1)),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);
