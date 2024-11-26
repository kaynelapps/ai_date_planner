import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_af.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('af'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('en', 'CA'),
    Locale('en', 'GB'),
    Locale('es'),
    Locale('fil'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('ko'),
    Locale('nl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('zh')
  ];

  /// No description provided for @skipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipButton;

  /// No description provided for @onboardTitle1.
  ///
  /// In en, this message translates to:
  /// **'Understand Your Emotional State'**
  String get onboardTitle1;

  /// No description provided for @onboardDesc1.
  ///
  /// In en, this message translates to:
  /// **'Our AI helps you and your partner assess your emotional states through a series of thoughtful questions, ensuring the best date ideas for your mood.'**
  String get onboardDesc1;

  /// No description provided for @onboardTitle2.
  ///
  /// In en, this message translates to:
  /// **'Get Personalized Date Ideas'**
  String get onboardTitle2;

  /// No description provided for @onboardDesc2.
  ///
  /// In en, this message translates to:
  /// **'Based on your emotional insights, our AI suggests tailored date ideas that match both of your preferences and current feelings.'**
  String get onboardDesc2;

  /// No description provided for @onboardTitle3.
  ///
  /// In en, this message translates to:
  /// **'Stay Connected and Engaged'**
  String get onboardTitle3;

  /// No description provided for @onboardDesc3.
  ///
  /// In en, this message translates to:
  /// **'Keep the spark alive by organizing fun, meaningful, and unique dates that help strengthen your relationship over time.'**
  String get onboardDesc3;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SoulPlan'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The Perfect Date'**
  String get appSubtitle;

  /// No description provided for @planDateButton.
  ///
  /// In en, this message translates to:
  /// **'Plan The Perfect Date'**
  String get planDateButton;

  /// No description provided for @shareMomentsButton.
  ///
  /// In en, this message translates to:
  /// **'Share Your Moments'**
  String get shareMomentsButton;

  /// No description provided for @favoriteDatesButton.
  ///
  /// In en, this message translates to:
  /// **'Favorite Dates'**
  String get favoriteDatesButton;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @ratingDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you love our AI Date Planner?'**
  String get ratingDialogTitle;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @submitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitButton;

  /// No description provided for @selectYourGender.
  ///
  /// In en, this message translates to:
  /// **'Select Your Gender'**
  String get selectYourGender;

  /// No description provided for @selectPartnerGender.
  ///
  /// In en, this message translates to:
  /// **'Select Your Partner\'s Gender'**
  String get selectPartnerGender;

  /// No description provided for @yourQuestionnaire.
  ///
  /// In en, this message translates to:
  /// **'Your Questionnaire'**
  String get yourQuestionnaire;

  /// No description provided for @partnerQuestionnaire.
  ///
  /// In en, this message translates to:
  /// **'Partner\'s Questionnaire'**
  String get partnerQuestionnaire;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @nonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-binary'**
  String get nonBinary;

  /// No description provided for @transgender.
  ///
  /// In en, this message translates to:
  /// **'Transgender'**
  String get transgender;

  /// No description provided for @genderFluid.
  ///
  /// In en, this message translates to:
  /// **'Gender fluid'**
  String get genderFluid;

  /// No description provided for @genderQueer.
  ///
  /// In en, this message translates to:
  /// **'Gender queer'**
  String get genderQueer;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @preferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get preferNotToSay;

  /// No description provided for @question1.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get question1;

  /// No description provided for @question1_option1.
  ///
  /// In en, this message translates to:
  /// **'Energized'**
  String get question1_option1;

  /// No description provided for @question1_option2.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get question1_option2;

  /// No description provided for @question1_option3.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get question1_option3;

  /// No description provided for @question1_option4.
  ///
  /// In en, this message translates to:
  /// **'Stressed'**
  String get question1_option4;

  /// No description provided for @question1_option5.
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get question1_option5;

  /// No description provided for @question1_option6.
  ///
  /// In en, this message translates to:
  /// **'Pensive'**
  String get question1_option6;

  /// No description provided for @question1_option7.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get question1_option7;

  /// No description provided for @question2.
  ///
  /// In en, this message translates to:
  /// **'How was your day?'**
  String get question2;

  /// No description provided for @question2_option1.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get question2_option1;

  /// No description provided for @question2_option2.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get question2_option2;

  /// No description provided for @question2_option3.
  ///
  /// In en, this message translates to:
  /// **'Just okay'**
  String get question2_option3;

  /// No description provided for @question2_option4.
  ///
  /// In en, this message translates to:
  /// **'Rough'**
  String get question2_option4;

  /// No description provided for @question2_option5.
  ///
  /// In en, this message translates to:
  /// **'Exhausting'**
  String get question2_option5;

  /// No description provided for @question3.
  ///
  /// In en, this message translates to:
  /// **'What\'s your current energy level like?'**
  String get question3;

  /// No description provided for @question3_option1.
  ///
  /// In en, this message translates to:
  /// **'Full of energy'**
  String get question3_option1;

  /// No description provided for @question3_option2.
  ///
  /// In en, this message translates to:
  /// **'Pretty good'**
  String get question3_option2;

  /// No description provided for @question3_option3.
  ///
  /// In en, this message translates to:
  /// **'Low on energy'**
  String get question3_option3;

  /// No description provided for @question4.
  ///
  /// In en, this message translates to:
  /// **'What kind of vibe are you looking for in your next date?'**
  String get question4;

  /// No description provided for @question4_option1.
  ///
  /// In en, this message translates to:
  /// **'Fun and adventurous'**
  String get question4_option1;

  /// No description provided for @question4_option2.
  ///
  /// In en, this message translates to:
  /// **'Romantic and intimate'**
  String get question4_option2;

  /// No description provided for @question4_option3.
  ///
  /// In en, this message translates to:
  /// **'Relaxed and casual'**
  String get question4_option3;

  /// No description provided for @question4_option4.
  ///
  /// In en, this message translates to:
  /// **'Something new and exciting'**
  String get question4_option4;

  /// No description provided for @question5.
  ///
  /// In en, this message translates to:
  /// **'Are you feeling more talkative or prefer something quieter?'**
  String get question5;

  /// No description provided for @question5_option1.
  ///
  /// In en, this message translates to:
  /// **'Ready for good conversation'**
  String get question5_option1;

  /// No description provided for @question5_option2.
  ///
  /// In en, this message translates to:
  /// **'Prefer something low-key'**
  String get question5_option2;

  /// No description provided for @question6.
  ///
  /// In en, this message translates to:
  /// **'What would make your day better right now?'**
  String get question6;

  /// No description provided for @question6_option1.
  ///
  /// In en, this message translates to:
  /// **'A fun activity to get me moving'**
  String get question6_option1;

  /// No description provided for @question6_option2.
  ///
  /// In en, this message translates to:
  /// **'A quiet moment to relax and unwind'**
  String get question6_option2;

  /// No description provided for @question6_option3.
  ///
  /// In en, this message translates to:
  /// **'Something exciting to distract me'**
  String get question6_option3;

  /// No description provided for @question6_option4.
  ///
  /// In en, this message translates to:
  /// **'Just some good company'**
  String get question6_option4;

  /// No description provided for @dateIdeas.
  ///
  /// In en, this message translates to:
  /// **'Date ideas'**
  String get dateIdeas;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @yourCity.
  ///
  /// In en, this message translates to:
  /// **'Your city'**
  String get yourCity;

  /// No description provided for @resultsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Date Suggestions'**
  String get resultsScreenTitle;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @findLocations.
  ///
  /// In en, this message translates to:
  /// **'Find Locations'**
  String get findLocations;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Oops! We couldn\'t generate date ideas.'**
  String get errorMessage;

  /// No description provided for @generatingDescription.
  ///
  /// In en, this message translates to:
  /// **'Generating description...'**
  String get generatingDescription;

  /// No description provided for @dateSuggestionDefault.
  ///
  /// In en, this message translates to:
  /// **'Date Suggestion'**
  String get dateSuggestionDefault;

  /// No description provided for @sectionIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get sectionIntroduction;

  /// No description provided for @sectionStepGuide.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step guide'**
  String get sectionStepGuide;

  /// No description provided for @sectionAccommodation.
  ///
  /// In en, this message translates to:
  /// **'Accommodation'**
  String get sectionAccommodation;

  /// No description provided for @sectionTouches.
  ///
  /// In en, this message translates to:
  /// **'Special touches'**
  String get sectionTouches;

  /// No description provided for @sectionConversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation tips'**
  String get sectionConversation;

  /// No description provided for @sectionPreparation.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get sectionPreparation;

  /// No description provided for @sectionAdaptation.
  ///
  /// In en, this message translates to:
  /// **'Adaptation'**
  String get sectionAdaptation;

  /// No description provided for @atHomeDateTitle.
  ///
  /// In en, this message translates to:
  /// **'At-Home Date Idea'**
  String get atHomeDateTitle;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load advice. Please try again.'**
  String get loadingError;

  /// No description provided for @sectionSpecialTouches.
  ///
  /// In en, this message translates to:
  /// **'Special touches'**
  String get sectionSpecialTouches;

  /// No description provided for @sectionConversationTips.
  ///
  /// In en, this message translates to:
  /// **'Conversation tips'**
  String get sectionConversationTips;

  /// No description provided for @customizeYourDate.
  ///
  /// In en, this message translates to:
  /// **'Customize Your Date'**
  String get customizeYourDate;

  /// No description provided for @yourDateIdea.
  ///
  /// In en, this message translates to:
  /// **'Your Date Idea'**
  String get yourDateIdea;

  /// No description provided for @dateIdea.
  ///
  /// In en, this message translates to:
  /// **'Date Idea'**
  String get dateIdea;

  /// No description provided for @selectPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Select Price Range'**
  String get selectPriceRange;

  /// No description provided for @enterCity.
  ///
  /// In en, this message translates to:
  /// **'Enter City'**
  String get enterCity;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., New York'**
  String get cityHint;

  /// No description provided for @findPerfectPlaces.
  ///
  /// In en, this message translates to:
  /// **'Find Perfect Places'**
  String get findPerfectPlaces;

  /// No description provided for @priceNotApplicable.
  ///
  /// In en, this message translates to:
  /// **'Price range not applicable for this activity'**
  String get priceNotApplicable;

  /// No description provided for @selectPriceAndCity.
  ///
  /// In en, this message translates to:
  /// **'Please select a price range (if applicable) and enter a city'**
  String get selectPriceAndCity;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @priceDollar.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get priceDollar;

  /// No description provided for @priceDollar2.
  ///
  /// In en, this message translates to:
  /// **'\$\$'**
  String get priceDollar2;

  /// No description provided for @priceDollar3.
  ///
  /// In en, this message translates to:
  /// **'\$\$\$'**
  String get priceDollar3;

  /// No description provided for @priceDollar4.
  ///
  /// In en, this message translates to:
  /// **'\$\$\$\$'**
  String get priceDollar4;

  /// No description provided for @favoriteDatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorite Dates'**
  String get favoriteDatesTitle;

  /// No description provided for @noFavoriteDates.
  ///
  /// In en, this message translates to:
  /// **'No favorite dates yet'**
  String get noFavoriteDates;

  /// No description provided for @startAddingDates.
  ///
  /// In en, this message translates to:
  /// **'Start adding dates to your favorites!'**
  String get startAddingDates;

  /// No description provided for @defaultDateSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Date Suggestion'**
  String get defaultDateSuggestion;

  /// No description provided for @switchingPartners.
  ///
  /// In en, this message translates to:
  /// **'Switching Partners'**
  String get switchingPartners;

  /// No description provided for @intermediateMessage1.
  ///
  /// In en, this message translates to:
  /// **'Get ready for your partner\'s questions...'**
  String get intermediateMessage1;

  /// No description provided for @intermediateMessage2.
  ///
  /// In en, this message translates to:
  /// **'Preparing for the next round...'**
  String get intermediateMessage2;

  /// No description provided for @intermediateMessage3.
  ///
  /// In en, this message translates to:
  /// **'Almost there! Your partner\'s turn is coming up...'**
  String get intermediateMessage3;

  /// No description provided for @intermediateMessage4.
  ///
  /// In en, this message translates to:
  /// **'Switching gears for your partner\'s input...'**
  String get intermediateMessage4;

  /// No description provided for @loadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Planning Your Perfect Date'**
  String get loadingTitle;

  /// No description provided for @loadingMessage1.
  ///
  /// In en, this message translates to:
  /// **'Creating magical moments just for you...'**
  String get loadingMessage1;

  /// No description provided for @loadingMessage2.
  ///
  /// In en, this message translates to:
  /// **'Exploring romantic spots in {city}...'**
  String loadingMessage2(Object city);

  /// No description provided for @loadingMessage3.
  ///
  /// In en, this message translates to:
  /// **'Crafting the perfect {suggestion} experience...'**
  String loadingMessage3(Object suggestion);

  /// No description provided for @loadingMessage4.
  ///
  /// In en, this message translates to:
  /// **'Finding amazing dates within {priceRange}...'**
  String loadingMessage4(Object priceRange);

  /// No description provided for @showAdButton.
  ///
  /// In en, this message translates to:
  /// **'Show Ad'**
  String get showAdButton;

  /// No description provided for @loadingMessage11.
  ///
  /// In en, this message translates to:
  /// **'Searching for the perfect spots in {city}...'**
  String loadingMessage11(Object city);

  /// No description provided for @loadingMessage22.
  ///
  /// In en, this message translates to:
  /// **'Finding {suggestion} places just for you...'**
  String loadingMessage22(Object suggestion);

  /// No description provided for @loadingMessage33.
  ///
  /// In en, this message translates to:
  /// **'Exploring options within your {priceRange} range...'**
  String loadingMessage33(Object priceRange);

  /// No description provided for @loadingMessage44.
  ///
  /// In en, this message translates to:
  /// **'Uncovering hidden gems in the area...'**
  String get loadingMessage44;

  /// No description provided for @moment.
  ///
  /// In en, this message translates to:
  /// **'Moment'**
  String get moment;

  /// No description provided for @flagButton.
  ///
  /// In en, this message translates to:
  /// **'Flag'**
  String get flagButton;

  /// No description provided for @deleteMomentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Moment'**
  String get deleteMomentTitle;

  /// No description provided for @deleteMomentMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this moment?'**
  String get deleteMomentMessage;

  /// No description provided for @flagPictureText.
  ///
  /// In en, this message translates to:
  /// **'Flag Picture'**
  String get flagPictureText;

  /// No description provided for @flagCommentText.
  ///
  /// In en, this message translates to:
  /// **'Flag Comment'**
  String get flagCommentText;

  /// No description provided for @deleteCommentText.
  ///
  /// In en, this message translates to:
  /// **'Delete Comment'**
  String get deleteCommentText;

  /// No description provided for @deleteCommentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Comment'**
  String get deleteCommentTitle;

  /// No description provided for @deleteCommentMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this comment?'**
  String get deleteCommentMessage;

  /// No description provided for @commentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// No description provided for @replyText.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get replyText;

  /// No description provided for @addCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addCommentHint;

  /// No description provided for @postButton.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postButton;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequired;

  /// No description provided for @loginRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'You need to login to post comments'**
  String get loginRequiredMessage;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @momentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Moment not found'**
  String get momentNotFound;

  /// No description provided for @replyToUserHint.
  ///
  /// In en, this message translates to:
  /// **'Reply to @{username}'**
  String replyToUserHint(Object username);

  /// No description provided for @dateIdea_adventurePark.
  ///
  /// In en, this message translates to:
  /// **'Adventure park visit'**
  String get dateIdea_adventurePark;

  /// No description provided for @dateIdea_danceClass.
  ///
  /// In en, this message translates to:
  /// **'Dance class together'**
  String get dateIdea_danceClass;

  /// No description provided for @dateIdea_rockClimbing.
  ///
  /// In en, this message translates to:
  /// **'Rock climbing'**
  String get dateIdea_rockClimbing;

  /// No description provided for @dateIdea_bikeRidePicnic.
  ///
  /// In en, this message translates to:
  /// **'Bike ride and picnic'**
  String get dateIdea_bikeRidePicnic;

  /// No description provided for @dateIdea_escapeRoom.
  ///
  /// In en, this message translates to:
  /// **'Escape room challenge'**
  String get dateIdea_escapeRoom;

  /// No description provided for @dateIdea_cookingClass.
  ///
  /// In en, this message translates to:
  /// **'Cooking class'**
  String get dateIdea_cookingClass;

  /// No description provided for @dateIdea_artGallery.
  ///
  /// In en, this message translates to:
  /// **'Art gallery tour with coffee break'**
  String get dateIdea_artGallery;

  /// No description provided for @dateIdea_sunsetHike.
  ///
  /// In en, this message translates to:
  /// **'Sunset hike with relaxation at the top'**
  String get dateIdea_sunsetHike;

  /// No description provided for @dateIdea_kayaking.
  ///
  /// In en, this message translates to:
  /// **'Kayaking with picnic stops'**
  String get dateIdea_kayaking;

  /// No description provided for @dateIdea_boardGameCafe.
  ///
  /// In en, this message translates to:
  /// **'Board game café visit'**
  String get dateIdea_boardGameCafe;

  /// No description provided for @dateIdea_stargazingPicnic.
  ///
  /// In en, this message translates to:
  /// **'Stargazing picnic'**
  String get dateIdea_stargazingPicnic;

  /// No description provided for @dateIdea_spaDayy.
  ///
  /// In en, this message translates to:
  /// **'Couples spa day'**
  String get dateIdea_spaDayy;

  /// No description provided for @dateIdea_wineTasting.
  ///
  /// In en, this message translates to:
  /// **'Wine tasting at home'**
  String get dateIdea_wineTasting;

  /// No description provided for @dateIdea_bookstoreCafe.
  ///
  /// In en, this message translates to:
  /// **'Bookstore browsing and café visit'**
  String get dateIdea_bookstoreCafe;

  /// No description provided for @dateIdea_yoga.
  ///
  /// In en, this message translates to:
  /// **'Gentle yoga class together'**
  String get dateIdea_yoga;

  /// No description provided for @dateIdea_meditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation and mindfulness session'**
  String get dateIdea_meditation;

  /// No description provided for @dateIdea_natureWalk.
  ///
  /// In en, this message translates to:
  /// **'Nature walk in a quiet park'**
  String get dateIdea_natureWalk;

  /// No description provided for @dateIdea_couplesMassage.
  ///
  /// In en, this message translates to:
  /// **'Couples massage'**
  String get dateIdea_couplesMassage;

  /// No description provided for @dateIdea_musicConcert.
  ///
  /// In en, this message translates to:
  /// **'Relaxing music concert'**
  String get dateIdea_musicConcert;

  /// No description provided for @dateIdea_potteryClass.
  ///
  /// In en, this message translates to:
  /// **'Pottery or painting class'**
  String get dateIdea_potteryClass;

  /// No description provided for @dateIdea_mysteryDate.
  ///
  /// In en, this message translates to:
  /// **'Surprise mystery date (pre-planned activities)'**
  String get dateIdea_mysteryDate;

  /// No description provided for @dateIdea_foodTour.
  ///
  /// In en, this message translates to:
  /// **'Local food tour'**
  String get dateIdea_foodTour;

  /// No description provided for @dateIdea_amusementPark.
  ///
  /// In en, this message translates to:
  /// **'Amusement park visit'**
  String get dateIdea_amusementPark;

  /// No description provided for @dateIdea_comedyShow.
  ///
  /// In en, this message translates to:
  /// **'Live comedy show'**
  String get dateIdea_comedyShow;

  /// No description provided for @dateIdea_karaoke.
  ///
  /// In en, this message translates to:
  /// **'Karaoke night'**
  String get dateIdea_karaoke;

  /// No description provided for @dateIdea_movieMarathon.
  ///
  /// In en, this message translates to:
  /// **'Movie marathon with favorite snacks'**
  String get dateIdea_movieMarathon;

  /// No description provided for @dateIdea_scenicDrive.
  ///
  /// In en, this message translates to:
  /// **'Scenic drive with stops at viewpoints'**
  String get dateIdea_scenicDrive;

  /// No description provided for @dateIdea_relaxingPicnic.
  ///
  /// In en, this message translates to:
  /// **'Relaxing picnic in a park'**
  String get dateIdea_relaxingPicnic;

  /// No description provided for @dateIdea_bookReading.
  ///
  /// In en, this message translates to:
  /// **'Couples book reading session'**
  String get dateIdea_bookReading;

  /// No description provided for @dateIdea_stargazing.
  ///
  /// In en, this message translates to:
  /// **'Stargazing from a comfortable spot'**
  String get dateIdea_stargazing;

  /// No description provided for @dateIdea_newRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Try a new restaurant together'**
  String get dateIdea_newRestaurant;

  /// No description provided for @dateIdea_museum.
  ///
  /// In en, this message translates to:
  /// **'Visit a local museum'**
  String get dateIdea_museum;

  /// No description provided for @dateIdea_cookingClass2.
  ///
  /// In en, this message translates to:
  /// **'Take a cooking class'**
  String get dateIdea_cookingClass2;

  /// No description provided for @dateIdea_natureWalk2.
  ///
  /// In en, this message translates to:
  /// **'Go for a nature walk'**
  String get dateIdea_natureWalk2;

  /// No description provided for @dateIdea_localEvent.
  ///
  /// In en, this message translates to:
  /// **'Attend a local event or festival'**
  String get dateIdea_localEvent;

  /// No description provided for @momentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Moments'**
  String get momentsTitle;

  /// No description provided for @uploadNewMoment.
  ///
  /// In en, this message translates to:
  /// **'Upload New Moment'**
  String get uploadNewMoment;

  /// No description provided for @myMomentsTab.
  ///
  /// In en, this message translates to:
  /// **'My Moments'**
  String get myMomentsTab;

  /// No description provided for @peopleMomentsTab.
  ///
  /// In en, this message translates to:
  /// **'People\'s Moments'**
  String get peopleMomentsTab;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Denied'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'This app needs location permission to function properly'**
  String get locationPermissionMessage;

  /// No description provided for @locationErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Error'**
  String get locationErrorTitle;

  /// No description provided for @locationErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to get your current location. Please try again later'**
  String get locationErrorMessage;

  /// No description provided for @storagePermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required to share moments'**
  String get storagePermissionMessage;

  /// No description provided for @imagePickError.
  ///
  /// In en, this message translates to:
  /// **'Error picking image. Please try again'**
  String get imagePickError;

  /// No description provided for @selectImageLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please select an image and ensure location is available'**
  String get selectImageLocationMessage;

  /// No description provided for @userEmailNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'User email not available'**
  String get userEmailNotAvailable;

  /// No description provided for @uploadSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Moment uploaded successfully!'**
  String get uploadSuccessMessage;

  /// No description provided for @uploadFailMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload moment. Please try again'**
  String get uploadFailMessage;

  /// No description provided for @uploadingImage.
  ///
  /// In en, this message translates to:
  /// **'Uploading image...'**
  String get uploadingImage;

  /// No description provided for @noMomentsDisplay.
  ///
  /// In en, this message translates to:
  /// **'No moments to display'**
  String get noMomentsDisplay;

  /// No description provided for @settingsButton.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsButton;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @distanceAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get distanceAll;

  /// No description provided for @distance5km.
  ///
  /// In en, this message translates to:
  /// **'5km'**
  String get distance5km;

  /// No description provided for @distance10km.
  ///
  /// In en, this message translates to:
  /// **'10km'**
  String get distance10km;

  /// No description provided for @distance20km.
  ///
  /// In en, this message translates to:
  /// **'20km'**
  String get distance20km;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @accountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagement;

  /// No description provided for @changeNickname.
  ///
  /// In en, this message translates to:
  /// **'Change Nickname'**
  String get changeNickname;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @changeNicknameTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Nickname'**
  String get changeNicknameTitle;

  /// No description provided for @changeEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmailTitle;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @enterNewNickname.
  ///
  /// In en, this message translates to:
  /// **'Enter new nickname'**
  String get enterNewNickname;

  /// No description provided for @enterNewEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter new email'**
  String get enterNewEmail;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountConfirmation;

  /// No description provided for @changeButton.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @nicknameUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Nickname updated successfully'**
  String get nicknameUpdateSuccess;

  /// No description provided for @emailUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email updated successfully'**
  String get emailUpdateSuccess;

  /// No description provided for @passwordUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdateSuccess;

  /// No description provided for @emailUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update email: {error}'**
  String emailUpdateError(Object error);

  /// No description provided for @passwordUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update password: {error}'**
  String passwordUpdateError(Object error);

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @suggestedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Suggested Places'**
  String get suggestedPlaces;

  /// No description provided for @noPlacesFound.
  ///
  /// In en, this message translates to:
  /// **'No places found for this suggestion.'**
  String get noPlacesFound;

  /// No description provided for @failedToLoadPlaces.
  ///
  /// In en, this message translates to:
  /// **'Failed to load places: {error}'**
  String failedToLoadPlaces(Object error);

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String categoryLabel(Object category);

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// No description provided for @noAddress.
  ///
  /// In en, this message translates to:
  /// **'No address'**
  String get noAddress;

  /// No description provided for @atHomeKeyword.
  ///
  /// In en, this message translates to:
  /// **'at home'**
  String get atHomeKeyword;

  /// No description provided for @homeKeyword.
  ///
  /// In en, this message translates to:
  /// **'home'**
  String get homeKeyword;

  /// No description provided for @netflixKeyword.
  ///
  /// In en, this message translates to:
  /// **'netflix'**
  String get netflixKeyword;

  /// No description provided for @movieNightKeyword.
  ///
  /// In en, this message translates to:
  /// **'movie night'**
  String get movieNightKeyword;

  /// No description provided for @boardGameKeyword.
  ///
  /// In en, this message translates to:
  /// **'board game'**
  String get boardGameKeyword;

  /// No description provided for @cookingKeyword.
  ///
  /// In en, this message translates to:
  /// **'cooking'**
  String get cookingKeyword;

  /// No description provided for @bakingKeyword.
  ///
  /// In en, this message translates to:
  /// **'baking'**
  String get bakingKeyword;

  /// No description provided for @videoGameKeyword.
  ///
  /// In en, this message translates to:
  /// **'video game'**
  String get videoGameKeyword;

  /// No description provided for @puzzleKeyword.
  ///
  /// In en, this message translates to:
  /// **'puzzle'**
  String get puzzleKeyword;

  /// No description provided for @craftKeyword.
  ///
  /// In en, this message translates to:
  /// **'craft'**
  String get craftKeyword;

  /// No description provided for @placeDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Place Details'**
  String get placeDetailsTitle;

  /// No description provided for @loadingPlaceDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading place details...'**
  String get loadingPlaceDetails;

  /// No description provided for @placePhotosUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Photos unavailable'**
  String get placePhotosUnavailable;

  /// No description provided for @loadingPlaces.
  ///
  /// In en, this message translates to:
  /// **'Loading places...'**
  String get loadingPlaces;

  /// No description provided for @searchingVenues.
  ///
  /// In en, this message translates to:
  /// **'Searching for venues...'**
  String get searchingVenues;

  /// No description provided for @exploringOptions.
  ///
  /// In en, this message translates to:
  /// **'Exploring options in {city}...'**
  String exploringOptions(Object city);

  /// No description provided for @categoryOutdoor.
  ///
  /// In en, this message translates to:
  /// **'Outdoor'**
  String get categoryOutdoor;

  /// No description provided for @categoryCultural.
  ///
  /// In en, this message translates to:
  /// **'Cultural'**
  String get categoryCultural;

  /// No description provided for @placeDetailsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load place details'**
  String get placeDetailsLoadError;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get ratingLabel;

  /// No description provided for @websiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get websiteLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @categoryRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get categoryRestaurant;

  /// No description provided for @categoryBar.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get categoryBar;

  /// No description provided for @categoryCafe.
  ///
  /// In en, this message translates to:
  /// **'Café'**
  String get categoryCafe;

  /// No description provided for @categoryPark.
  ///
  /// In en, this message translates to:
  /// **'Park'**
  String get categoryPark;

  /// No description provided for @categoryMuseum.
  ///
  /// In en, this message translates to:
  /// **'Museum'**
  String get categoryMuseum;

  /// No description provided for @categoryTheater.
  ///
  /// In en, this message translates to:
  /// **'Theater'**
  String get categoryTheater;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @priceNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Price not available'**
  String get priceNotAvailable;

  /// No description provided for @priceFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get priceFree;

  /// No description provided for @priceInexpensive.
  ///
  /// In en, this message translates to:
  /// **'Inexpensive'**
  String get priceInexpensive;

  /// No description provided for @priceModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get priceModerate;

  /// No description provided for @priceExpensive.
  ///
  /// In en, this message translates to:
  /// **'Expensive'**
  String get priceExpensive;

  /// No description provided for @priceVeryExpensive.
  ///
  /// In en, this message translates to:
  /// **'Very Expensive'**
  String get priceVeryExpensive;

  /// No description provided for @openNow.
  ///
  /// In en, this message translates to:
  /// **'Open Now'**
  String get openNow;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @noRating.
  ///
  /// In en, this message translates to:
  /// **'No rating available'**
  String get noRating;

  /// No description provided for @noPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone available'**
  String get noPhone;

  /// No description provided for @noWebsite.
  ///
  /// In en, this message translates to:
  /// **'No website available'**
  String get noWebsite;

  /// No description provided for @imageLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get imageLoadError;

  /// No description provided for @noImagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No images available'**
  String get noImagesAvailable;

  /// No description provided for @getDirections.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// No description provided for @callNow.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get callNow;

  /// No description provided for @visitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit Website'**
  String get visitWebsite;

  /// No description provided for @sharePlace.
  ///
  /// In en, this message translates to:
  /// **'Share Place'**
  String get sharePlace;

  /// No description provided for @backButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Back to previous screen'**
  String get backButtonLabel;

  /// No description provided for @imageSlideshow.
  ///
  /// In en, this message translates to:
  /// **'Place photos slideshow'**
  String get imageSlideshow;

  /// No description provided for @placeDetailsCard.
  ///
  /// In en, this message translates to:
  /// **'Place details information'**
  String get placeDetailsCard;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service & Content Guidelines (EULA)'**
  String get termsOfServiceTitle;

  /// No description provided for @termsOfServiceIntro.
  ///
  /// In en, this message translates to:
  /// **'By using our app, you agree to these terms:'**
  String get termsOfServiceIntro;

  /// No description provided for @termsItem1.
  ///
  /// In en, this message translates to:
  /// **'Zero Tolerance Policy: We strictly prohibit hate speech, explicit content, violence, discrimination, harassment, or illegal activities.'**
  String get termsItem1;

  /// No description provided for @termsItem2.
  ///
  /// In en, this message translates to:
  /// **'Content Moderation: All user content is subject to review. We reserve the right to remove any content violating our guidelines.'**
  String get termsItem2;

  /// No description provided for @termsItem3.
  ///
  /// In en, this message translates to:
  /// **'User Behavior: You must not engage in harassment, bullying, spam, or create a hostile environment for others.'**
  String get termsItem3;

  /// No description provided for @termsItem4.
  ///
  /// In en, this message translates to:
  /// **'Violations: Content removal, account suspension, or permanent termination may result from violating these terms.'**
  String get termsItem4;

  /// No description provided for @termsItem5.
  ///
  /// In en, this message translates to:
  /// **'Content Reporting: Users must report inappropriate content. All reports will be investigated promptly.'**
  String get termsItem5;

  /// No description provided for @termsItem6.
  ///
  /// In en, this message translates to:
  /// **'Age Requirements: Users must be 13+ to create content. Content targeting minors inappropriately is forbidden.'**
  String get termsItem6;

  /// No description provided for @termsItem7.
  ///
  /// In en, this message translates to:
  /// **'Account Responsibility: You are responsible for all content posted through your account.'**
  String get termsItem7;

  /// No description provided for @termsItem8.
  ///
  /// In en, this message translates to:
  /// **'Content Rights: We reserve the right to remove, edit, or block any content or user at our discretion.'**
  String get termsItem8;

  /// No description provided for @acceptTermsButton.
  ///
  /// In en, this message translates to:
  /// **'Accept Terms'**
  String get acceptTermsButton;

  /// No description provided for @declineButton.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get declineButton;

  /// No description provided for @pickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick an Image'**
  String get pickImage;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @makePublic.
  ///
  /// In en, this message translates to:
  /// **'Make public:'**
  String get makePublic;

  /// No description provided for @uploadMomentButton.
  ///
  /// In en, this message translates to:
  /// **'Upload Moment'**
  String get uploadMomentButton;

  /// No description provided for @uploadingMoment.
  ///
  /// In en, this message translates to:
  /// **'Uploading moment...'**
  String get uploadingMoment;

  /// No description provided for @selectImageLocationError.
  ///
  /// In en, this message translates to:
  /// **'Please select an image and ensure location is available'**
  String get selectImageLocationError;

  /// No description provided for @userEmailError.
  ///
  /// In en, this message translates to:
  /// **'User email not available'**
  String get userEmailError;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Moment uploaded successfully!'**
  String get uploadSuccess;

  /// No description provided for @uploadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload moment. Please try again.'**
  String get uploadError;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @imageQualityCompression.
  ///
  /// In en, this message translates to:
  /// **'Image Quality'**
  String get imageQualityCompression;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @processingImage.
  ///
  /// In en, this message translates to:
  /// **'Processing image...'**
  String get processingImage;

  /// No description provided for @savingMoment.
  ///
  /// In en, this message translates to:
  /// **'Saving your moment...'**
  String get savingMoment;

  /// No description provided for @updatingFeed.
  ///
  /// In en, this message translates to:
  /// **'Updating feed...'**
  String get updatingFeed;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SoulPlan'**
  String get welcomeMessage;

  /// No description provided for @continueWithoutLogin.
  ///
  /// In en, this message translates to:
  /// **'Continue without login'**
  String get continueWithoutLogin;

  /// No description provided for @emailField.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailField;

  /// No description provided for @passwordField.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordField;

  /// No description provided for @nicknameField.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameField;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @signInGoogleButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInGoogleButton;

  /// No description provided for @signInAppleButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInAppleButton;

  /// No description provided for @haveAccountText.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get haveAccountText;

  /// No description provided for @needAccountText.
  ///
  /// In en, this message translates to:
  /// **'Need an account? Sign Up'**
  String get needAccountText;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String fieldRequired(Object field);

  /// No description provided for @nicknameTakenError.
  ///
  /// In en, this message translates to:
  /// **'Nickname is already taken. Please choose another one.'**
  String get nicknameTakenError;

  /// No description provided for @signUpError.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed. The email might already be in use.'**
  String get signUpError;

  /// No description provided for @signInError.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed. Please check your email and password.'**
  String get signInError;

  /// No description provided for @userIdError.
  ///
  /// In en, this message translates to:
  /// **'Failed to get user ID. Please try again.'**
  String get userIdError;

  /// No description provided for @googleSignInError.
  ///
  /// In en, this message translates to:
  /// **'Google sign in failed. Please try again.'**
  String get googleSignInError;

  /// No description provided for @appleSignInError.
  ///
  /// In en, this message translates to:
  /// **'Apple sign in failed'**
  String get appleSignInError;

  /// No description provided for @nicknameError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save nickname: {error}'**
  String nicknameError(Object error);

  /// No description provided for @generalError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String generalError(Object error);

  /// No description provided for @loadingText.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingText;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String validationError(Object field);

  /// No description provided for @welcomeToApp.
  ///
  /// In en, this message translates to:
  /// **'AI Date Ideas'**
  String get welcomeToApp;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Dating Ideas & Social Moments'**
  String get appDescription;

  /// No description provided for @aiDates.
  ///
  /// In en, this message translates to:
  /// **'AI Dates'**
  String get aiDates;

  /// No description provided for @favoriteDates.
  ///
  /// In en, this message translates to:
  /// **'Favorite Dates'**
  String get favoriteDates;

  /// No description provided for @shareMoments.
  ///
  /// In en, this message translates to:
  /// **'Share Moments'**
  String get shareMoments;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get selectLanguage;

  /// No description provided for @moodBasedDatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood Based Dates'**
  String get moodBasedDatesTitle;

  /// No description provided for @moodBasedDatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Get personalized date ideas based on your current mood and preferences'**
  String get moodBasedDatesDescription;

  /// No description provided for @eventBasedDatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Based Dates'**
  String get eventBasedDatesTitle;

  /// No description provided for @christmasDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Christmas Date Ideas'**
  String get christmasDateTitle;

  /// No description provided for @christmasDateDescription.
  ///
  /// In en, this message translates to:
  /// **'Magical winter dates filled with festive activities, cozy moments, and holiday spirit'**
  String get christmasDateDescription;

  /// No description provided for @valentinesDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Valentine\'s Day Date'**
  String get valentinesDateTitle;

  /// No description provided for @valentinesDateDescription.
  ///
  /// In en, this message translates to:
  /// **'Romantic experiences designed to celebrate your love in unique and memorable ways'**
  String get valentinesDateDescription;

  /// No description provided for @newYearDateTitle.
  ///
  /// In en, this message translates to:
  /// **'New Year\'s Eve Date'**
  String get newYearDateTitle;

  /// No description provided for @newYearDateDescription.
  ///
  /// In en, this message translates to:
  /// **'Special moments to end the year and welcome new beginnings together'**
  String get newYearDateDescription;

  /// No description provided for @anniversaryDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Anniversary Date Ideas'**
  String get anniversaryDateTitle;

  /// No description provided for @anniversaryDateDescription.
  ///
  /// In en, this message translates to:
  /// **'Meaningful celebrations to commemorate your journey of love'**
  String get anniversaryDateDescription;

  /// No description provided for @birthdayDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Birthday Date Ideas'**
  String get birthdayDateTitle;

  /// No description provided for @birthdayDateDescription.
  ///
  /// In en, this message translates to:
  /// **'Fun and personalized date ideas to make their special day unforgettable'**
  String get birthdayDateDescription;

  /// No description provided for @memoryMakerTitle.
  ///
  /// In en, this message translates to:
  /// **'Memory Maker'**
  String get memoryMakerTitle;

  /// No description provided for @memoryMakerDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a photo album of your favorite moments'**
  String get memoryMakerDesc;

  /// No description provided for @danceNightTitle.
  ///
  /// In en, this message translates to:
  /// **'Dance Night'**
  String get danceNightTitle;

  /// No description provided for @danceNightDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn a new dance style together'**
  String get danceNightDesc;

  /// No description provided for @budgetDateTitle.
  ///
  /// In en, this message translates to:
  /// **'\$20 Date Challenge'**
  String get budgetDateTitle;

  /// No description provided for @budgetDateDesc.
  ///
  /// In en, this message translates to:
  /// **'Plan an entire date with a \$20 budget'**
  String get budgetDateDesc;

  /// No description provided for @artShowTitle.
  ///
  /// In en, this message translates to:
  /// **'Couple Art Show'**
  String get artShowTitle;

  /// No description provided for @artShowDesc.
  ///
  /// In en, this message translates to:
  /// **'Create art pieces in 30 minutes for your gallery'**
  String get artShowDesc;

  /// No description provided for @fearConquerTitle.
  ///
  /// In en, this message translates to:
  /// **'Conquer a Fear'**
  String get fearConquerTitle;

  /// No description provided for @fearConquerDesc.
  ///
  /// In en, this message translates to:
  /// **'Face a common fear as a team'**
  String get fearConquerDesc;

  /// No description provided for @newSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'New Skills Challenge'**
  String get newSkillsTitle;

  /// No description provided for @newSkillsDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn a new skill together'**
  String get newSkillsDesc;

  /// No description provided for @complimentsTitle.
  ///
  /// In en, this message translates to:
  /// **'7 Compliments Date'**
  String get complimentsTitle;

  /// No description provided for @complimentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Give each other 7 genuine compliments'**
  String get complimentsDesc;

  /// No description provided for @loveLettersTitle.
  ///
  /// In en, this message translates to:
  /// **'Love Letter Swap'**
  String get loveLettersTitle;

  /// No description provided for @loveLettersDesc.
  ///
  /// In en, this message translates to:
  /// **'Write and exchange heartfelt love letters'**
  String get loveLettersDesc;

  /// No description provided for @firstDateRecreationTitle.
  ///
  /// In en, this message translates to:
  /// **'First Date Recreation'**
  String get firstDateRecreationTitle;

  /// No description provided for @firstDateRecreationDesc.
  ///
  /// In en, this message translates to:
  /// **'Recreate your very first date together'**
  String get firstDateRecreationDesc;

  /// No description provided for @tasteTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Blind Taste Test'**
  String get tasteTestTitle;

  /// No description provided for @tasteTestDesc.
  ///
  /// In en, this message translates to:
  /// **'Guess foods while blindfolded'**
  String get tasteTestDesc;

  /// No description provided for @deepQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Deep Questions'**
  String get deepQuestionsTitle;

  /// No description provided for @deepQuestionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Answer 5 meaningful relationship questions'**
  String get deepQuestionsDesc;

  /// No description provided for @gratitudeTitle.
  ///
  /// In en, this message translates to:
  /// **'Gratitude Challenge'**
  String get gratitudeTitle;

  /// No description provided for @gratitudeDesc.
  ///
  /// In en, this message translates to:
  /// **'Share 5 things you\'re grateful for about each other'**
  String get gratitudeDesc;

  /// No description provided for @futurePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Future Plan Date'**
  String get futurePlanTitle;

  /// No description provided for @futurePlanDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a vision board for your future together'**
  String get futurePlanDesc;

  /// No description provided for @volunteerTitle.
  ///
  /// In en, this message translates to:
  /// **'Volunteer Date'**
  String get volunteerTitle;

  /// No description provided for @volunteerDesc.
  ///
  /// In en, this message translates to:
  /// **'Spend time volunteering for a shared cause'**
  String get volunteerDesc;

  /// No description provided for @donationTitle.
  ///
  /// In en, this message translates to:
  /// **'Donation Challenge'**
  String get donationTitle;

  /// No description provided for @donationDesc.
  ///
  /// In en, this message translates to:
  /// **'Each choose one item to donate and share why'**
  String get donationDesc;

  /// No description provided for @accentTitle.
  ///
  /// In en, this message translates to:
  /// **'Accent Challenge'**
  String get accentTitle;

  /// No description provided for @accentDesc.
  ///
  /// In en, this message translates to:
  /// **'Speak in funny accents throughout the date'**
  String get accentDesc;

  /// No description provided for @roleSwapTitle.
  ///
  /// In en, this message translates to:
  /// **'Role-Swapping Date'**
  String get roleSwapTitle;

  /// No description provided for @roleSwapDesc.
  ///
  /// In en, this message translates to:
  /// **'Pretend to be each other for the entire date'**
  String get roleSwapDesc;

  /// No description provided for @oppositeDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Opposite Day'**
  String get oppositeDayTitle;

  /// No description provided for @oppositeDayDesc.
  ///
  /// In en, this message translates to:
  /// **'Let the usual follower take charge today'**
  String get oppositeDayDesc;

  /// No description provided for @coupleChallenges.
  ///
  /// In en, this message translates to:
  /// **'Couple Challenges'**
  String get coupleChallenges;

  /// No description provided for @firstDateAdventureTitle.
  ///
  /// In en, this message translates to:
  /// **'First Date Adventure'**
  String get firstDateAdventureTitle;

  /// No description provided for @firstDateAdventureDesc.
  ///
  /// In en, this message translates to:
  /// **'One of you becomes the Mystery Planner! Surprise your partner with a secret adventure full of twists, turns, and exciting moments.'**
  String get firstDateAdventureDesc;

  /// No description provided for @romanticChefTitle.
  ///
  /// In en, this message translates to:
  /// **'Romantic Chef'**
  String get romanticChefTitle;

  /// No description provided for @romanticChefDesc.
  ///
  /// In en, this message translates to:
  /// **'Cook a meal together from scratch'**
  String get romanticChefDesc;

  /// No description provided for @startChallenge.
  ///
  /// In en, this message translates to:
  /// **'Start Challenge'**
  String get startChallenge;

  /// No description provided for @exploreideas.
  ///
  /// In en, this message translates to:
  /// **'Explore Ideas'**
  String get exploreideas;

  /// No description provided for @accountActions.
  ///
  /// In en, this message translates to:
  /// **'Account Actions'**
  String get accountActions;

  /// No description provided for @disconnectAccount.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Account'**
  String get disconnectAccount;

  /// No description provided for @disconnectAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Account'**
  String get disconnectAccountTitle;

  /// No description provided for @disconnectAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disconnect from your account? You can always sign back in later.'**
  String get disconnectAccountConfirmation;

  /// No description provided for @disconnectButton.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnectButton;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['af', 'bn', 'de', 'en', 'es', 'fil', 'fr', 'hi', 'id', 'ko', 'nl', 'pt', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en': {
  switch (locale.countryCode) {
    case 'CA': return AppLocalizationsEnCa();
case 'GB': return AppLocalizationsEnGb();
   }
  break;
   }
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'af': return AppLocalizationsAf();
    case 'bn': return AppLocalizationsBn();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fil': return AppLocalizationsFil();
    case 'fr': return AppLocalizationsFr();
    case 'hi': return AppLocalizationsHi();
    case 'id': return AppLocalizationsId();
    case 'ko': return AppLocalizationsKo();
    case 'nl': return AppLocalizationsNl();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
