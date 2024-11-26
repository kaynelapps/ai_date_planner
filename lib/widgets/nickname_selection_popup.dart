import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soulplan_ai_fun_date_ideas/services/auth_service.dart';
import 'dart:ui';

class NicknameSelectionPopup extends StatefulWidget {
  final Function(String) onNicknameConfirmed;

  const NicknameSelectionPopup({
    Key? key,
    required this.onNicknameConfirmed,
  }) : super(key: key);

  @override
  State<NicknameSelectionPopup> createState() => _NicknameSelectionPopupState();
}


class _NicknameSelectionPopupState extends State<NicknameSelectionPopup> {
  final _formKey = GlobalKey<FormState>();
  String _nickname = '';
  bool _isChecking = false;

  void _submitNickname() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isChecking = true;
      });

      final authService = Provider.of<AuthService>(context, listen: false);
      bool isAvailable = await authService.checkNicknameAvailability(_nickname);

      setState(() {
        _isChecking = false;
      });

      if (isAvailable) {
        widget.onNicknameConfirmed(_nickname);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'This nickname is already taken. Please choose another one.',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: Colors.black.withOpacity(0.8),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image with overlay
        Positioned.fill(
          child: Image.asset(
            'assets/images/romantic_background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        // Glass morphism dialog
        Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Choose a Nickname',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                     const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: TextFormField(
                          style: GoogleFonts.poppins(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Nickname',
                            labelStyle: GoogleFonts.poppins(color: Colors.white70),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          validator: (value) => value!.isEmpty ? 'Please enter a nickname' : null,
                          onSaved: (value) => _nickname = value!,
                        ),
                      ),
                     const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: _isChecking ? null : _submitNickname,
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: _isChecking
                                    ? SizedBox(
                                  const SizedBox(
  width: 24,
  height: 24,
),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                                    : Text(
                                  'Confirm',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
