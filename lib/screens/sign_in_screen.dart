import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:soulplan_ai_fun_date_ideas/services/auth_service.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/main_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/widgets/nickname_selection_popup.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _email = '';
  String _password = '';
  String _nickname = '';
  bool _isSignUp = false;
  bool _isLoading = false;

  void _navigateAfterSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
          (route) => false,
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authService = Provider.of<AuthService>(context, listen: false);
      setState(() => _isLoading = true);

      try {
        bool success = _isSignUp
            ? await authService.signUp(_email, _password, _nickname)
            : await authService.signIn(_email, _password);

        if (success) {
          _navigateAfterSignIn();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed: ${e.toString()}')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _checkNicknameAndProceed(User user) async {
    final hasNickname = await _firestore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((doc) => doc.data()?['nickname'] != null);

    if (!hasNickname) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => NicknameSelectionPopup(
          onNicknameConfirmed: (nickname) async {
            await _firestore.collection('users').doc(user.uid).update({
              'nickname': nickname,
            });
            await _saveUserSession(user.email ?? '', nickname);
            Navigator.of(context).pop();
          },
        ),
      );
    }
    _navigateAfterSignIn();
  }



  Future<bool> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDocRef = _firestore.collection('users').doc(user.uid);
        final userDoc = await userDocRef.get();

        final userData = {
          'email': user.email,
          'lastSignIn': FieldValue.serverTimestamp(),
          'provider': 'google',
          'uid': user.uid,
          'displayName': user.displayName,
        };

        if (userDoc.exists) {
          final existingData = userDoc.data()!;
          if (existingData.containsKey('nickname')) {
            userData['nickname'] = existingData['nickname'];
          }
        }

        await userDocRef.set(userData, SetOptions(merge: true));

        if (userData.containsKey('nickname')) {
          await _saveUserSession(user.email ?? '', userData['nickname'] as String);
        }

        return true;
      }
      return false;
    } catch (e) {
      // Ignore avatar loading error but continue with sign in
      if (e.toString().contains('Failed to load OwnerAvatar')) {
        return true;
      }
      // Handle other errors
      print('Google Sign In Error: $e');
      return false;
    }
  }

  Future<void> _saveUserSession(String email, String nickname) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.updateUserNickname(email, nickname);
  }

  void _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      bool success = await signInWithGoogle();
      if (success) {
        User? user = _auth.currentUser;
        if (user != null) {
          await _checkNicknameAndProceed(user);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign in failed: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }





  void _signInWithApple() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      bool success = await authService.signInWithApple();
      if (success) {
        _navigateAfterSignIn();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Apple sign in failed: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.welcomeMessage,
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E2E2E),
          ),
        ).animate().fadeIn(delay: 300.ms).slideX(),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAuthForm(l10n),
                    SizedBox(height: 24),
                    _buildSocialButtons(l10n),
                    SizedBox(height: 16),
                    _buildSkipButton(l10n),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91C40)),
                ),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildAuthForm(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField(l10n.emailField, (value) => _email = value!, l10n),
            SizedBox(height: 16),
            _buildTextField(l10n.passwordField, (value) => _password = value!, l10n, isPassword: true),
            if (_isSignUp) ...[
              SizedBox(height: 16),
              _buildTextField(l10n.nicknameField, (value) => _nickname = value!, l10n),
            ],
            SizedBox(height: 24),
            _buildSubmitButton(l10n),
            SizedBox(height: 16),
            _buildToggleAuthModeButton(l10n),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY();
  }

  Widget _buildTextField(String label, Function(String?) onSaved, AppLocalizations l10n, {bool isPassword = false}) {
    return TextFormField(
      style: GoogleFonts.lato(color: Color(0xFF2E2E2E)),
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.lato(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE91C40)),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'This field is required';
        if (label == l10n.emailField && !value.contains('@')) return 'Please enter a valid email';
        if (label == l10n.passwordField && value.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
      onSaved: onSaved,
    );
  }

  Widget _buildSubmitButton(AppLocalizations l10n) {
    return ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE91C40),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        _isSignUp ? l10n.signUpButton : l10n.signInButton,
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildToggleAuthModeButton(AppLocalizations l10n) {
    return TextButton(
      onPressed: () => setState(() => _isSignUp = !_isSignUp),
      child: Text(
        _isSignUp ? l10n.haveAccountText : l10n.needAccountText,
        style: GoogleFonts.lato(
          color: Color(0xFFE91C40),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSocialButtons(AppLocalizations l10n) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(FontAwesomeIcons.google),
          label: Text('Sign in with Google'),
          onPressed: _signInWithGoogle,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF2E2E2E),
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        if (Theme.of(context).platform == TargetPlatform.iOS) ...[
          SizedBox(height: 16),
          SignInWithAppleButton(
            onPressed: _signInWithApple,
            style: SignInWithAppleButtonStyle.black,
          ),
        ],
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildSkipButton(AppLocalizations l10n) {
    return TextButton(
      onPressed: _navigateAfterSignIn,
      child: Text(
        l10n.continueWithoutLogin,
        style: GoogleFonts.lato(
          color: Color(0xFF2E2E2E),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ).animate().fadeIn(delay: 300.ms);
  }
}
