import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:io' show Platform;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/ad_ids.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class LoadingScreen1 extends StatefulWidget {
  final String suggestion;
  final String priceRange;
  final String city;

  const LoadingScreen1({
    Key? key,
    required this.suggestion,
    required this.priceRange,
    required this.city,
  }) : super(key: key);

  @override
  _LoadingScreen1State createState() => _LoadingScreen1State();
}

class _LoadingScreen1State extends State<LoadingScreen1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _messageIndex = 0;
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  bool _isFacebookAdLoaded = false;
  final String _androidAdUnitId = AdIds.loadingScreen1Android;
  final String _iOSAdUnitId = AdIds.loadingScreen1IOS;
  String get _adUnitId => Platform.isAndroid ? _androidAdUnitId : _iOSAdUnitId;
  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _setupTimers();
    _initializeAds();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  Future<void> _initializeAds() async {
    await FacebookAudienceNetwork.init();
    _loadFacebookInterstitial();
  }

  void _loadFacebookInterstitial() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: Platform.isAndroid
          ? AdIds.loadingScreen1FacebookAndroid
          : AdIds.loadingScreen1FacebookIOS,
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          setState(() => _isFacebookAdLoaded = true);
        } else if (result == InterstitialAdResult.ERROR) {
          _loadInterstitialAd();
        }
      },
    );
  }
  List<String> _getLocalizedMessages(BuildContext context) {
    return [
      AppLocalizations.of(context)!.loadingMessage11(widget.city),
      AppLocalizations.of(context)!.loadingMessage22(widget.suggestion),
      AppLocalizations.of(context)!.loadingMessage33(widget.priceRange),
      AppLocalizations.of(context)!.loadingMessage44,
    ];
  }

  void _changeMessage() {
    if (mounted) {
      setState(() {
        _messageIndex = (_messageIndex + 1) % _getLocalizedMessages(context).length;
      });
      Future.delayed(Duration(seconds: 3), _changeMessage);
    }
  }

  void _setupTimers() {
    Future.delayed(Duration(seconds: 3), _changeMessage);
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) _showInterstitialAd();
    });
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
            _isAdLoaded = true;
          });
          _handleAdLoaded(ad);
        },
        onAdFailedToLoad: (error) {
          print('Ad failed to load: $error');
          _isAdLoaded = false;
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showInterstitialAd() async {
    if (_isFacebookAdLoaded) {
      await FacebookInterstitialAd.showInterstitialAd();
      Navigator.of(context).pop();
    } else if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      Navigator.pop(context);
    }
  }
  void _handleAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    _isAdLoaded = true;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _handleAdDismissed(ad);
        Navigator.pop(context);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _handleAdFailedToShow(ad, error);
        Navigator.pop(context);
      },
    );
  }

  void _handleAdDismissed(InterstitialAd ad) {
    _interstitialAd = null;
    _isAdLoaded = false;
    ad.dispose();
  }

  void _handleAdFailedToShow(InterstitialAd ad, AdError error) {
    _interstitialAd = null;
    _isAdLoaded = false;
    ad.dispose();
  }

  @override
  void dispose() {
    _controller.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = _getLocalizedMessages(context);

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
            AppLocalizations.of(context)!.loadingPlaces,
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
    child: Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
    color: Color(0xFFE91C40).withOpacity(0.1),
    shape: BoxShape.circle,
    ),
    child: Icon(
    Icons.location_on_rounded,
    size: 40,
    color: Color(0xFFE91C40),
    ),
    ),
    ).animate()
        .fadeIn()
        .scale(delay: 200.ms, duration: 500.ms),
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
            fontSize: 18,
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
