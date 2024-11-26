import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/language_selection_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import '../constants/ad_ids.dart';
import 'dart:io' show Platform;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  InterstitialAd? _admobInterstitial;
  bool _isAdmobLoaded = false;
  bool _isFacebookAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _controller.forward();
    _initializeAppAndAds();
  }

  Future<void> _initializeAppAndAds() async {
    await _initializeAds();
    await Future.delayed(const Duration(seconds: 5)); // Increased delay
    await _showAd();
  }

  Future<void> _initializeAds() async {
    await MobileAds.instance.initialize();
    await FacebookAudienceNetwork.init();

    // Load AdMob first
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? AdIds.splashScreenAdmobAndroid
          : AdIds.splashScreenAdmobIOS,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _admobInterstitial = ad;
            _isAdmobLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          // If AdMob fails, try Facebook
          FacebookInterstitialAd.loadInterstitialAd(
            placementId: Platform.isAndroid
                ? AdIds.splashScreenFacebookAndroid
                : AdIds.splashScreenFacebookIOS,
            listener: (result, value) {
              if (result == InterstitialAdResult.LOADED) {
                setState(() => _isFacebookAdLoaded = true);
              }
            },
          );
        },
      ),
    );
  }

  void _loadAdmobInterstitial() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? AdIds.splashScreenAdmobAndroid
          : AdIds.splashScreenAdmobIOS,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _admobInterstitial = ad;
            _isAdmobLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          print('AdMob Interstitial failed to load: $error');
        },
      ),
    );
  }

  Future<void> _showAd() async {
    if (_isFacebookAdLoaded) {
      await FacebookInterstitialAd.showInterstitialAd();
      _navigateToNext();
    } else if (_isAdmobLoaded && _admobInterstitial != null) {
      _admobInterstitial!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _navigateToNext();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _navigateToNext();
        },
      );
      _admobInterstitial!.show();
    } else {
      _navigateToNext();
    }
  }

  void _navigateToNext() async {
    await checkFirstSeen();
  }

  Future<void> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LanguageSelectionScreen(
            isFirstTime: !_seen,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _admobInterstitial?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Stack(
                children: [
                  Image.asset(
                    'images/splash_background.jpg',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.7),
                          Colors.white.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center( // Added Center widget here
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, // Added this
                  children: [
                    const Spacer(),
                    Center( // Added Center widget for the title container
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: TitleWidget(),
                      ).animate()
                          .fadeIn(duration: 800.ms)
                          .scale(delay: 300.ms, duration: 500.ms),
                    ),
                    const SizedBox(height: 30),
                    Center( // Added Center widget for the loading indicator
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                          strokeWidth: 3,
                        ),
                      ).animate().fadeIn(delay: 500.ms),
                    ),
                    const Spacer(),
                    Center( // Added Center widget for version text
                      child: VersionText(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'SoulPlan',
      style: GoogleFonts.lato(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        shadows: [
          Shadow(
            color: Colors.white.withOpacity(0.5),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    ).animate()
        .fadeIn(duration: 800.ms, delay: 300.ms)
        .moveY(begin: 30, duration: 800.ms, curve: Curves.easeOutQuad);
  }
}

class VersionText extends StatelessWidget {
  const VersionText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        'Crafting Your Perfect Date',
        style: GoogleFonts.lato(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
      ),
    ).animate()
        .fadeIn(duration: 800.ms, delay: 1000.ms)
        .slideX(begin: -30, duration: 500.ms);
  }
}
