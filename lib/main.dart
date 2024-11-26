import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/questionnaire_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/splash_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/main_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/language_selection_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/services/firebase_service.dart';
import 'package:soulplan_ai_fun_date_ideas/services/auth_service.dart';
import 'package:soulplan_ai_fun_date_ideas/providers/moment_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:soulplan_ai_fun_date_ideas/utils/permission_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:soulplan_ai_fun_date_ideas/providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';




class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  try {
    await Firebase.initializeApp(
      options: Platform.isIOS
          ? const FirebaseOptions(
          apiKey: 'AIzaSyCdTjl9VCsnos9-PQxIe2Kbf_KgqFiGNgQ',
          appId: '1:543297399935:ios:74642b18481e4fa55da34a',
          messagingSenderId: '543297399935',
          projectId: 'soulplan-dateplanner',
          storageBucket: 'soulplan-dateplanner.appspot.com',
          iosBundleId: 'com.aifun.dateideas.planadate',
          databaseURL: 'https://soulplan-dateplanner-default-rtdb.firebaseio.com'
      )
          : const FirebaseOptions(
          apiKey: 'AIzaSyAuglgklOUcCkyeKyUx_PtDvud3NWGj4-4',
          appId: '1:543297399935:android:a00c55db93fc9f975da34a',
          messagingSenderId: '543297399935',
          projectId: 'soulplan-dateplanner',
          storageBucket: 'soulplan-dateplanner.appspot.com',
          databaseURL: 'https://soulplan-dateplanner-default-rtdb.firebaseio.com'
      ),
    );

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );

    await MobileAds.instance.initialize();
    await _preloadAds();
    await dotenv.load(fileName: '.env');
    await PermissionUtils.requestStoragePermission();
    await PermissionUtils.requestLocationPermission();
    await requestTrackingAuthorization();
  } catch (e) {
    print('Error during initialization: $e');
  }

  runApp(MyApp(
    initialRoute: '/splash',
    isFirstTime: true,
  ));
}

Future<void> _preloadAds() async {
  try {
    // Preload interstitial ads
    InterstitialAd.load(
      adUnitId: Platform.isIOS
          ? 'your-ios-interstitial-id'
          : 'your-android-interstitial-id',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          // Store the loaded ad for later use
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );

    // Preload native ads if you're using them
    await NativeAd(
      adUnitId: Platform.isIOS
          ? 'your-ios-native-id'
          : 'your-android-native-id',
      factoryId: 'listTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ),
    ).load();
  } catch (e) {
    print('Error preloading ads: $e');
  }
}

Future<void> requestTrackingAuthorization() async {
  try {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  } catch (e) {
    print('Error requesting tracking authorization: $e');
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final bool isFirstTime;

  const MyApp({
    Key? key,
    required this.initialRoute,
    required this.isFirstTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Locale?>(
      future: _getStoredLocale(),
      builder: (context, snapshot) {
        return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(),
          ),
          ChangeNotifierProvider(
            create: (_) => MomentProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => LocaleProvider(),
          ),
        ],
        child: Consumer<LocaleProvider>(
          builder: (context, localeProvider, _) {
            return MaterialApp(
              title: 'AI Date Planner',
              theme: ThemeData(
                fontFamily: 'Raleway',
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en', 'US'),
                Locale('en', 'GB'),
                Locale('en', 'CA'),
                Locale('ko'),
                Locale('zh'),
                Locale('es'),
                Locale('fr'),
                Locale('de'),
                Locale('hi'),
                Locale('pt'),
                Locale('pt', 'BR'),
                Locale('ru'),
                Locale('in'),
                Locale('fil'),
                Locale('bn'),
                Locale('af'),
                Locale('nl'),
              ],
              locale: localeProvider.locale ?? snapshot.data,
              localeResolutionCallback: (locale, supportedLocales) {
                return locale;
              },
              initialRoute: initialRoute,
              routes: {
                '/language': (context) => LanguageSelectionScreen(isFirstTime: isFirstTime),
                '/splash': (context) => SplashScreen(),
                '/main': (context) => MainScreen(),
                '/questionnaire': (context) => QuestionnaireScreen(),
                '/home': (context) => MainScreen(), // Added this line
              },

              debugShowCheckedModeBanner: false,
            );
          },
        ),
        );
      },
    );
  }

  Future<Locale?> _getStoredLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      final parts = languageCode.split('_');
      return parts.length > 1
          ? Locale(parts[0], parts[1])
          : Locale(parts[0]);
    }
    return null;
  }
}
