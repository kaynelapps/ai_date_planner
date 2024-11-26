import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/questionnaire_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/favorite_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/widgets/date_card.dart';

import 'package:soulplan_ai_fun_date_ideas/screens/new_year_date_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/christmas_dates_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/anniversary_date_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/valentines_date_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/birthday_date_screen.dart';

class StartScreen extends StatelessWidget {
  List<Map<String, dynamic>> getEvents(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {
        'title': l10n.christmasDateTitle,
        'description': l10n.christmasDateDescription,
        'imageUrl': 'assets/images/christmas_date.jpg',
      },
      {
        'title': l10n.valentinesDateTitle,
        'description': l10n.valentinesDateDescription,
        'imageUrl': 'assets/images/valentines_date.jpg',
      },
      {
        'title': l10n.newYearDateTitle,
        'description': l10n.newYearDateDescription,
        'imageUrl': 'assets/images/newyear_date.jpg',
      },
      {
        'title': l10n.anniversaryDateTitle,
        'description': l10n.anniversaryDateDescription,
        'imageUrl': 'assets/images/anniversary_date.jpg',
      },
      {
        'title': l10n.birthdayDateTitle,
        'description': l10n.birthdayDateDescription,
        'imageUrl': 'assets/images/birthday_date.jpg',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final events = getEvents(context);

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
                    _buildMoodBasedSection(context),
                    _buildEventBasedSection(context, events),
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
            l10n.welcomeToApp,
            style: GoogleFonts.lato(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: Color(0xFFE91C40)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoriteScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodBasedSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateCard(
            title: l10n.moodBasedDatesTitle,
            description: l10n.moodBasedDatesDescription,
            imageUrl: 'assets/images/mood_dates.jpg',
            heightFactor: 1.2,
            onExplore: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuestionnaireScreen()),
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(
            begin: 0.2,
            end: 0,
            duration: 600.ms,
            curve: Curves.easeOut,
          ),
        ],
      ),
    );
  }

  Widget _buildEventBasedSection(BuildContext context, List<Map<String, dynamic>> events) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.eventBasedDatesTitle,
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ).animate().fadeIn(duration: 600.ms),
          SizedBox(height: 16),
          MasonryGridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: events.length,
            itemBuilder: (context, index) {
              final heightFactor = index % 2 == 0 ? 1.0 : 1.2;
              return DateCard(
                title: events[index]['title'],
                description: events[index]['description'],
                imageUrl: events[index]['imageUrl'],
                heightFactor: heightFactor,
                onExplore: () {
                  if (events[index]['title'] == AppLocalizations.of(context)!.christmasDateTitle) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChristmasDateScreen()),
                    );
                  } else if (events[index]['title'] == AppLocalizations.of(context)!.newYearDateTitle) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewYearDateScreen()),
                    );
                  } else if (events[index]['title'] == AppLocalizations.of(context)!.anniversaryDateTitle) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnniversaryDateScreen()),
                    );
                  } else if (events[index]['title'] == AppLocalizations.of(context)!.valentinesDateTitle) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ValentinesDateScreen()),
                    );
                  } else if (events[index]['title'] == AppLocalizations.of(context)!.birthdayDateTitle) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BirthdayDateScreen()),
                    );
                  }
                },
              ).animate().fadeIn(
                duration: 600.ms,
                delay: Duration(milliseconds: 200 * index),
              );
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

}
