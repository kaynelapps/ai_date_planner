import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'dart:io' show Platform;
import '../constants/ad_ids.dart';
import '../services/auth_service.dart';
import '../screens/sign_in_screen.dart';
import '../screens/main_screen.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  late PageController pageController;
  int currentIndexPage = 0;
  List<NativeAd?> _admobNativeAds = List.generate(3, (_) => null);
  List<Widget?> _facebookNativeAds = List.generate(3, (_) => null);
  List<bool> _isAdMobNativeAdLoaded = List.generate(3, (_) => false);
  List<bool> _isFacebookNativeAdLoaded = List.generate(3, (_) => false);

  List<Map<String, dynamic>> getSliderList(BuildContext context) {
    return [
      {
        "icon": 'assets/images/dessert.jpg',
        "title": AppLocalizations.of(context)!.onboardTitle1,
        "description": AppLocalizations.of(context)!.onboardDesc1,
      },
      {
        "icon": 'assets/images/kayaking.jpg',
        "title": AppLocalizations.of(context)!.onboardTitle2,
        "description": AppLocalizations.of(context)!.onboardDesc2,
      },
      {
        "icon": 'assets/images/taste_test.jpg',
        "title": AppLocalizations.of(context)!.onboardTitle3,
        "description": AppLocalizations.of(context)!.onboardDesc3,
      },
    ];
  }
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    FacebookAudienceNetwork.init();
    for (int i = 0; i < 3; i++) {
      _loadFacebookNativeAd(i);
      _loadAdMobNativeAd(i);
    }
  }

  void _loadFacebookNativeAd(int pageIndex) {
    _facebookNativeAds[pageIndex] = FacebookNativeAd(
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
            _isFacebookNativeAdLoaded[pageIndex] = true;
          });
        } else if (result == NativeAdResult.ERROR || result == NativeAdResult.CLICKED) {
          _loadAdMobNativeAd(pageIndex);
        }
      },
    );
  }

  void _loadAdMobNativeAd(int pageIndex) {
    _admobNativeAds[pageIndex] = NativeAd(
      adUnitId: Platform.isAndroid
          ? AdIds.languageScreenNativeAdmobAndroid
          : AdIds.languageScreenNativeAdmobIOS,
      factoryId: 'listTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdMobNativeAdLoaded[pageIndex] = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }
  void _finishOnboarding() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    bool isLoggedIn = await authService.isLoggedIn();

    if (context.mounted) {
      if (isLoggedIn) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sliderList = getSliderList(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildPageView(sliderList),
            ),
            _buildBottomNavigation(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.welcomeToApp,
            style: GoogleFonts.lato(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),
          TextButton(
            onPressed: _finishOnboarding,
            child: Text(
              'Skip',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91C40),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
  Widget _buildPageView(List<Map<String, dynamic>> sliderList) {
    return PageView.builder(
      itemCount: sliderList.length,
      controller: pageController,
      onPageChanged: (index) {
        setState(() {
          currentIndexPage = index;
        });
      },
      itemBuilder: (context, index) => _buildPage(sliderList[index], index),
    );
  }

  Widget _buildPage(Map<String, dynamic> pageData, int pageIndex) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  pageData['icon'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            pageData['title'],
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(),
          SizedBox(height: 16),
          Text(
            pageData['description'],
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms).slideY(),
          if (_isFacebookNativeAdLoaded[pageIndex] && _facebookNativeAds[pageIndex] != null)
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 300,
              child: _facebookNativeAds[pageIndex]!,
            )
          else if (_isAdMobNativeAdLoaded[pageIndex] && _admobNativeAds[pageIndex] != null)
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 300,
              child: AdWidget(ad: _admobNativeAds[pageIndex]!),
            ),
        ],
      ),
    );
  }
  Widget _buildBottomNavigation() {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPageIndicator(),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      children: List.generate(
        3,
            (index) => Container(
          margin: EdgeInsets.only(right: 8),
          height: 8,
          width: currentIndexPage == index ? 24 : 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: currentIndexPage == index
                ? Color(0xFFE91C40)
                : Colors.grey[300],
          ),
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE91C40),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        if (currentIndexPage < 2) {
          pageController.nextPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _finishOnboarding();
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentIndexPage == 2 ? 'Get Started' : 'Next',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 20, color: Colors.white),
        ],
      ),
    ).animate().fadeIn();
  }

  @override
  void dispose() {
    for (var ad in _admobNativeAds) {
      ad?.dispose();
    }
    _facebookNativeAds = List.generate(3, (_) => null);
    super.dispose();
  }
}
