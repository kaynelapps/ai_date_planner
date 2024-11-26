import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flag/flag.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'dart:io' show Platform;
import '../constants/ad_ids.dart';
import '../screens/main_screen.dart';
import '../models/language_model.dart';
import '../providers/locale_provider.dart';
import '../services/auth_service.dart';
import '../screens/on_board.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFirstTime;

  LanguageSelectionScreen({Key? key, required this.isFirstTime}) : super(key: key);

  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}
class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  bool _isFacebookNativeAdLoaded = false;
  bool _isAdMobNativeAdLoaded = false;
  NativeAd? _admobNativeAd;
  Widget? _facebookNativeAd;

  final List<LanguageModel> languages = [
    LanguageModel(name: "English (US)", code: "en_US", countryCode: "US"),
    LanguageModel(name: "English (UK)", code: "en_GB", countryCode: "GB"),
    LanguageModel(name: "English (CA)", code: "en_CA", countryCode: "CA"),
    LanguageModel(name: "한국어", code: "ko", countryCode: "KR"),
    LanguageModel(name: "中文", code: "zh", countryCode: "CN"),
    LanguageModel(name: "Español", code: "es", countryCode: "ES"),
    LanguageModel(name: "Français", code: "fr", countryCode: "FR"),
    LanguageModel(name: "Deutsch", code: "de", countryCode: "DE"),
    LanguageModel(name: "हिंदी", code: "hi", countryCode: "IN"),
    LanguageModel(name: "Português", code: "pt", countryCode: "PT"),
    LanguageModel(name: "Português (BR)", code: "pt_BR", countryCode: "BR"),
    LanguageModel(name: "Русский", code: "ru", countryCode: "RU"),
    LanguageModel(name: "Bahasa Indonesia", code: "in", countryCode: "ID"),
    LanguageModel(name: "Filipino", code: "fil", countryCode: "PH"),
    LanguageModel(name: "বাংলা", code: "bn", countryCode: "BD"),
    LanguageModel(name: "Afrikaans", code: "af", countryCode: "ZA"),
    LanguageModel(name: "Nederlands", code: "nl", countryCode: "NL"),
  ];
  @override
  void initState() {
    super.initState();
    print('Loading Facebook Native Ad');
    _loadFacebookNativeAd();
    _loadAdMobNativeAd();
  }


  void _loadFacebookNativeAd() {
    setState(() {
      _facebookNativeAd = FacebookNativeAd(
        placementId: Platform.isAndroid
            ? AdIds.languageScreenNativeFacebookAndroid
            : AdIds.languageScreenNativeFacebookIOS,
        adType: NativeAdType.NATIVE_AD_VERTICAL,
        width: double.infinity,
        height: 300,
        keepAlive: true,
        backgroundColor: Colors.white,
        titleColor: Color(0xFF2E2E2E),
        descriptionColor: Color(0xFF757575),
        buttonColor: Color(0xFFE91C40),
        buttonTitleColor: Colors.white,
        buttonBorderColor: Color(0xFFE91C40),
        listener: (result, value) {
          if (result == NativeAdResult.LOADED) {
            setState(() {
              _isFacebookNativeAdLoaded = true;
              _facebookNativeAd = value;
            });
          }
        },
      );
    });
  }

  void _loadAdMobNativeAd() {
    _admobNativeAd = NativeAd(
      adUnitId: Platform.isAndroid
          ? AdIds.languageScreenNativeAdmobAndroid
          : AdIds.languageScreenNativeAdmobIOS,
      factoryId: 'listTile',
      request: AdRequest(),
      nativeAdOptions: NativeAdOptions(
        adChoicesPlacement: AdChoicesPlacement.topRightCorner,
        mediaAspectRatio: MediaAspectRatio.landscape,
        videoOptions: VideoOptions(
          startMuted: true,
        ),
      ),
      customOptions: {
        'backgroundColor': '#FFFFFF',
        'titleTextColor': '#2E2E2E',
        'descriptionTextColor': '#757575',
        'buttonColor': '#FFE91C40',
        'buttonTextColor': '#FFFFFF',
      },
      listener: NativeAdListener(
        onAdLoaded: (ad) => setState(() => _isAdMobNativeAdLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _loadFacebookNativeAd();
        },
      ),
    );
    _admobNativeAd?.load();
  }


  Future<void> _selectLanguage(BuildContext context, String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);

    final parts = languageCode.split('_');
    final locale = parts.length > 1
        ? Locale(parts[0], parts[1])
        : Locale(parts[0]);

    if (context.mounted) {
      Provider.of<LocaleProvider>(context, listen: false).setLocale(locale);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OnBoard()),
            (route) => false,
      );
    }
  }

  Widget _buildLanguageItem(BuildContext context, LanguageModel language) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        leading: Flag.fromString(
          language.countryCode,
          height: 24,
          width: 32,
        ),
        title: Text(
          language.name,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Color(0xFF2E2E2E),
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Color(0xFF2E2E2E)),
        onTap: () => _selectLanguage(context, language.code),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Choose Your Language',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E2E2E),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ...languages.map((language) => _buildLanguageItem(context, language)).toList(),
                  ],
                ),
              ),
            ),
          ),
          if (_isFacebookNativeAdLoaded && _facebookNativeAd != null)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: _facebookNativeAd!,
            )
          else if (_isAdMobNativeAdLoaded && _admobNativeAd != null)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              height: 300,
              child: AdWidget(ad: _admobNativeAd!),
            ),
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
