import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:io' show Platform;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/ad_ids.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class IntermediateScreen extends StatefulWidget {
  @override
  _IntermediateScreenState createState() => _IntermediateScreenState();
}
class _IntermediateScreenState extends State<IntermediateScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFacebookAdLoaded = false;
  int _messageIndex = 0;
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  final String _androidAdUnitId = AdIds.intermediateScreenAndroid;
  final String _iOSAdUnitId = AdIds.intermediateScreenIOS;
  String get _adUnitId => Platform.isAndroid ? _androidAdUnitId : _iOSAdUnitId;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _initializeAds();
    _navigateAfterDelay();
    _changeMessage();
  }
  Future<void> _initializeAds() async {
    await FacebookAudienceNetwork.init();
    _loadFacebookInterstitial();
  }

  void _loadFacebookInterstitial() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: Platform.isAndroid
          ? AdIds.intermediateScreenFacebookAndroid
          : AdIds.intermediateScreenFacebookIOS,
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          setState(() => _isFacebookAdLoaded = true);
        } else if (result == InterstitialAdResult.ERROR) {
          _loadInterstitialAd();
        }
      },
    );
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  List<String> _getMessages(BuildContext context) {
    return [
      AppLocalizations.of(context)!.intermediateMessage1,
      AppLocalizations.of(context)!.intermediateMessage2,
      AppLocalizations.of(context)!.intermediateMessage3,
      AppLocalizations.of(context)!.intermediateMessage4,
    ];
  }

  void _navigateAfterDelay() {
    Future.delayed(Duration(seconds: 8), _showInterstitialAd);
  }

  void _changeMessage() {
    if (mounted) {
      setState(() => _messageIndex = (_messageIndex + 1) % 4);
      Future.delayed(Duration(seconds: 2), _changeMessage);
    }
  }
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => setState(() {
          _interstitialAd = ad;
          _isAdLoaded = true;
        }),
        onAdFailedToLoad: (error) => print('InterstitialAd failed to load: $error'),
      ),
    );
  }

  void _showInterstitialAd() async {
    if (_isFacebookAdLoaded) {
      await FacebookInterstitialAd.showInterstitialAd();
      Navigator.of(context).pop();
    } else if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          Navigator.of(context).pop();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          Navigator.of(context).pop();
        },
      );
      _interstitialAd!.show();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final messages = _getMessages(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF2E2E2E)),
          onPressed: () => Navigator.pop(context),
        ).animate().fadeIn(delay: 200.ms),
        title: Text(
          AppLocalizations.of(context)!.switchingPartners,
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
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(30),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: Icon(
                    Icons.favorite,
                    size: 100,
                    color: Color(0xFFE91C40),
                  ),
                ).animate().fadeIn(delay: 200.ms),
                SizedBox(height: 30),
                Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(3),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91C40)),
                    strokeWidth: 3,
                  ),
                ).animate().fadeIn(delay: 400.ms),
                SizedBox(height: 30),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    messages[_messageIndex],
                    key: ValueKey<int>(_messageIndex),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2E2E2E),
                      height: 1.5,
                    ),
                  ).animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
