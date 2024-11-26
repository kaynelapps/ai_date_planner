import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soulplan_ai_fun_date_ideas/providers/moment_provider.dart';
import 'package:soulplan_ai_fun_date_ideas/services/auth_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:soulplan_ai_fun_date_ideas/services/content_filter_service.dart';
import 'package:soulplan_ai_fun_date_ideas/widgets/glass_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui';

class UploadMomentScreen extends StatefulWidget {
  @override
  _UploadMomentScreenState createState() => _UploadMomentScreenState();
}

class _UploadMomentScreenState extends State<UploadMomentScreen> {
  XFile? _image;
  final _descriptionController = TextEditingController();
  bool _isPublic = false;
  Position? _currentPosition;
  final ContentFilterService _contentFilterService = ContentFilterService();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.uploadNewMoment,
            style: GoogleFonts.playfairDisplay(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'images/romantic_background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_image != null)
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(File(_image!.path), fit: BoxFit.cover),
                      ),
                    ),
                  SizedBox(height: 20),
                  GlassButton(
                    text: AppLocalizations.of(context)!.pickImage,
                    onPressed: _pickImage,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _descriptionController,
                    style: GoogleFonts.lato(color: Colors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.descriptionLabel,
                      labelStyle: GoogleFonts.lato(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.makePublic,
                            style: GoogleFonts.lato(color: Colors.white)),
                        Switch(
                          value: _isPublic,
                          onChanged: (value) => setState(() => _isPublic = value),
                          activeColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  GlassButton(
                    text: AppLocalizations.of(context)!.uploadMomentButton,
                    onPressed: () async {
                      await _uploadMoment();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() => _image = pickedFile);
    }
  }

  Future<void> _loadMoments() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final email = await authService.getCurrentUserEmail();
    if (email != null) {
      await Future.wait([
        Provider.of<MomentProvider>(context, listen: false).fetchUserMoments(email),
        Provider.of<MomentProvider>(context, listen: false).fetchPublicMoments(),
      ]);
      setState(() {});
    }
  }

  void _showLoadingPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.uploadingMoment,
                      style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _uploadMoment() async {
    if (_image == null || _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.selectImageLocationError,
            style: GoogleFonts.lato(color: Colors.white),
          ),
        ),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    final email = await authService.getCurrentUserEmail();
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.userEmailError,
            style: GoogleFonts.lato(color: Colors.white),
          ),
        ),
      );
      return;
    }

    String filteredDescription = _contentFilterService.filterContent(_descriptionController.text);

    _showLoadingPopup();

    try {
      await Provider.of<MomentProvider>(context, listen: false).createMoment(
        File(_image!.path),
        filteredDescription,
        _isPublic,
        email,
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      setState(() {
        _image = null;
        _descriptionController.clear();
        _isPublic = false;
      });

      await _loadMoments();

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.uploadSuccess,
            style: GoogleFonts.lato(color: Colors.white),
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.uploadError,
            style: GoogleFonts.lato(color: Colors.white),
          ),
        ),
      );
    }
  }
}
