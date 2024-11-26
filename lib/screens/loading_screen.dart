import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'dart:io' show Platform;
import '../constants/ad_ids.dart';

class LoadingScreen extends StatefulWidget {
  final String suggestion;
  final String priceRange;
  final String city;

  const LoadingScreen({
    Key? key,
    required this.suggestion,
    required this.priceRange,
    required this.city,
  }) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _messageIndex = 0;
  late List<String> _messages;

  InterstitialAd? _interstitialAd;
  bool _isAdmobLoaded = false;
  bool _isFacebookAdLoaded = false;

  final String _androidAdUnitId = AdIds.loadingScreenAndroid;
  final String _iOSAdUnitId = AdIds.loadingScreenIOS;
  String get _adUnitId => Platform.isAndroid ? _androidAdUnitId : _iOSAdUnitId;
  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _initializeAds();
    Future.delayed(Duration(seconds: 3), _changeMessage);
  }

  Future<void> _initializeAds() async {
    await FacebookAudienceNetwork.init();
    _loadFacebookInterstitial();
  }

  void _loadFacebookInterstitial() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: Platform.isAndroid
          ? AdIds.loadingScreenFacebookAndroid
          : AdIds.loadingScreenFacebookIOS,
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          setState(() => _isFacebookAdLoaded = true);
        } else if (result == InterstitialAdResult.ERROR) {
          _loadAdmobInterstitial();
        }
      },
    );
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }
  List<String> _getLocalizedMessages(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.loadingMessage1,
      l10n.loadingMessage2(widget.city),
      l10n.loadingMessage3(widget.suggestion),
      l10n.loadingMessage4(widget.priceRange)
    ];
  }

  void _changeMessage() {
    if (mounted) {
      setState(() => _messageIndex = (_messageIndex + 1) % _messages.length);
      Future.delayed(Duration(seconds: 3), _changeMessage);
    }
  }

  void _loadAdmobInterstitial() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => setState(() {
          _interstitialAd = ad;
          _isAdmobLoaded = true;
        }),
        onAdFailedToLoad: (error) => print('InterstitialAd failed to load: $error'),
      ),
    );
  }

  void _showInterstitialAd() async {
    if (_isFacebookAdLoaded) {
      await FacebookInterstitialAd.showInterstitialAd();
    } else if (_isAdmobLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
        },
      );
      _interstitialAd!.show();
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
    _messages = _getLocalizedMessages(context);

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
    AppLocalizations.of(context)!.loadingTitle,
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
                    _messages[_messageIndex],
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
                if (_isFacebookAdLoaded || _isAdmobLoaded) ...[
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _showInterstitialAd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE91C40),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.showAdButton,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
