import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/birthday_date_idea.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import '../constants/ad_ids.dart';
import 'dart:io' show Platform;


class BirthdayDateDetailScreen extends StatefulWidget {
  final BirthdayDateIdea dateIdea;

  const BirthdayDateDetailScreen({required this.dateIdea});

  @override
  _BirthdayDateDetailScreenState createState() => _BirthdayDateDetailScreenState();
}

class _BirthdayDateDetailScreenState extends State<BirthdayDateDetailScreen> {
  bool _isAdMobNativeAdLoaded = false;
  NativeAd? _admobNativeAd;
  bool _isFacebookNativeAdLoaded = false;
  Widget? _facebookNativeAd;

  @override
  void initState() {
    super.initState();
    _loadFacebookNativeAd();
    _loadAdMobNativeAd();
  }

  void _loadFacebookNativeAd() {
    _facebookNativeAd = FacebookNativeAd(
      placementId: Platform.isAndroid
          ? AdIds.languageScreenNativeFacebookAndroid
          : AdIds.languageScreenNativeFacebookIOS,
      adType: NativeAdType.NATIVE_AD_VERTICAL,
      width: double.infinity,
      height: 300,
      keepExpandedWhileLoading: false,
      expandAnimationDuraion: 300,
      listener: (result, value) {
        if (result == NativeAdResult.LOADED) {
          setState(() {
            _isFacebookNativeAdLoaded = true;
          });
        } else if (result == NativeAdResult.ERROR || result == NativeAdResult.CLICKED) {
          _loadAdMobNativeAd();
        }
      },
    );
  }
  void _loadAdMobNativeAd() {
    _admobNativeAd = NativeAd(
      adUnitId: Platform.isAndroid
          ? AdIds.languageScreenNativeAdmobAndroid
          : AdIds.languageScreenNativeAdmobIOS,
      factoryId: 'listTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdMobNativeAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(),
                    _buildDescription(),
                    _buildNativeAd(),
                    _buildSteps(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader(BuildContext context) {
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
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF2E2E2E)),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.dateIdea.title,
              style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E2E2E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 300,
      width: double.infinity,
      child: Hero(
        tag: widget.dateIdea.title,
        child: Image.asset(
          widget.dateIdea.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ).animate().fadeIn(duration: 600.ms),
          SizedBox(height: 12),
          Text(
            widget.dateIdea.description,
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Color(0xFF2E2E2E),
              height: 1.5,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildNativeAd() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          if (_isFacebookNativeAdLoaded && _facebookNativeAd != null)
            Container(
              height: 300,
              child: _facebookNativeAd!,
            )
          else if (_isAdMobNativeAdLoaded && _admobNativeAd != null)
            Container(
              height: 300,
              child: AdWidget(ad: _admobNativeAd!),
            ),
        ],
      ),
    );
  }
  Widget _buildSteps() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Steps to Make it Special',
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ).animate().fadeIn(duration: 600.ms),
          SizedBox(height: 16),
          ...widget.dateIdea.steps.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.cake, size: 16, color: Colors.pink),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Color(0xFF2E2E2E),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(
              duration: 600.ms,
              delay: Duration(milliseconds: 200 * entry.key),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _admobNativeAd?.dispose();
    super.dispose();
  }
}
