import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui';

import '../providers/moment_provider.dart';
import '../services/auth_service.dart';
import '../models/moment.dart';
import '../screens/moment_detail_screen.dart';
import '../screens/upload_moment_screen.dart';
import '../screens/sign_in_screen.dart';
import '../widgets/moment_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShareMomentsScreen extends StatefulWidget {
  const ShareMomentsScreen({Key? key}) : super(key: key);

  @override
  _ShareMomentsScreenState createState() => _ShareMomentsScreenState();
}
class _ShareMomentsScreenState extends State<ShareMomentsScreen> {
  String _selectedDistance = 'all';
  bool _isLoading = true;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadInitialData();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
      await _loadMoments();
    } catch (e) {
      // Handle location error
    }
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      await _loadMoments();
    } finally {
      setState(() => _isLoading = false);
    }
  }



  void _showDisconnectDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.disconnectAccountTitle),
        content: Text(AppLocalizations.of(context)!.disconnectAccountConfirmation),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancelButton),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.disconnectButton),
            onPressed: () {
              Navigator.pop(context); // Close the dialog first
              _disconnect(); // Call the disconnect method
            },
          ),
        ],
      ),
    );
  }


  Future<void> _loadMoments() async {
    setState(() => _isLoading = true);
    try {
      // Load public moments first, regardless of authentication
      await Provider.of<MomentProvider>(context, listen: false).fetchPublicMoments();

      // Then load user moments if authenticated
      final authService = Provider.of<AuthService>(context, listen: false);
      final email = await authService.getCurrentUserEmail();
      if (email != null) {
        await Provider.of<MomentProvider>(context, listen: false).fetchUserMoments(email);
      }

      print('Moments loaded successfully');
    } catch (e) {
      print('Error loading moments: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  void _showFullScreenImage(BuildContext context, Moment moment, bool isUserMoment) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MomentDetailScreen(
          momentId: moment.id,
          isUserMoment: isUserMoment,
        ),
      ),
    );
  }

  Future<void> _disconnect() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildMainContent(),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.shareMoments,
            style: GoogleFonts.lato(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Color(0xFF2E2E2E)),
            onPressed: () => _showDisconnectDialog(context),
          ),
        ],
      ),
    );
  }



  Widget _buildMainContent() {
    return Consumer<MomentProvider>(
      builder: (context, momentProvider, child) {
        final moments = momentProvider.publicMoments;
        print('Building UI with ${moments.length} public moments');

        return Column(
          children: [
            _buildDistanceFilter(),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : moments.isEmpty
                  ? Center(child: Text('No moments available'))
                  : MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                padding: EdgeInsets.all(16),
                itemCount: moments.length,
                itemBuilder: (context, index) {
                  final moment = moments[index];
                  final heightFactor = index % 2 == 0 ? 1.0 : 1.2;
                  return _buildMomentCard(moment, heightFactor);
                },
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildDistanceFilter() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedDistance,
          isExpanded: true,
          style: GoogleFonts.lato(color: Color(0xFF2E2E2E)),
          items: [
            DropdownMenuItem(value: 'all', child: Text(l10n.distanceAll)),
            DropdownMenuItem(value: '5', child: Text(l10n.distance5km)),
            DropdownMenuItem(value: '10', child: Text(l10n.distance10km)),
            DropdownMenuItem(value: '20', child: Text(l10n.distance20km)),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedDistance = value);
              _loadMoments();
            }
          },
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
  Widget _buildMomentCard(Moment moment, double heightFactor) {
    double? distance;
    if (_currentPosition != null) {
      distance = _calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        moment.latitude,
        moment.longitude,
      );
    }

    return MomentCard(
      moment: moment,
      heightFactor: heightFactor,
      distance: distance,
      onTap: () => _showFullScreenImage(context, moment, false),
    );
  }


  Widget _buildFooter(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE91C40),
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                l10n.uploadNewMoment,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadMomentScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
