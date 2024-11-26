import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:soulplan_ai_fun_date_ideas/models/challenge.dart';
import 'package:soulplan_ai_fun_date_ideas/widgets/challenge_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChallengesScreen extends StatelessWidget {
  List<Challenge> getChallenges(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      Challenge(
        title: l10n.firstDateAdventureTitle,
        description: l10n.firstDateAdventureDesc,
        points: 100,
        isCompleted: false,
        imageUrl: "assets/images/date_adventure.jpg",
      ),
      Challenge(
        title: l10n.romanticChefTitle,
        description: l10n.romanticChefDesc,
        points: 150,
        isCompleted: false,
        imageUrl: "assets/images/romantic_chef.jpg",
      ),
      Challenge(
        title: l10n.memoryMakerTitle,
        description: l10n.memoryMakerDesc,
        points: 200,
        isCompleted: true,
        imageUrl: "assets/images/memory_maker.jpg",
      ),
      Challenge(
        title: l10n.danceNightTitle,
        description: l10n.danceNightDesc,
        points: 180,
        isCompleted: false,
        imageUrl: "assets/images/dance_night.jpg",
      ),
      Challenge(
        title: l10n.budgetDateTitle,
        description: l10n.budgetDateDesc,
        points: 120,
        isCompleted: false,
        imageUrl: "assets/images/budget_date.jpg",
      ),
      Challenge(
        title: l10n.artShowTitle,
        description: l10n.artShowDesc,
        points: 160,
        isCompleted: false,
        imageUrl: "assets/images/art_show.jpg",
      ),
      Challenge(
        title: l10n.fearConquerTitle,
        description: l10n.fearConquerDesc,
        points: 250,
        isCompleted: false,
        imageUrl: "assets/images/fear_conquer.jpg",
      ),
      Challenge(
        title: l10n.newSkillsTitle,
        description: l10n.newSkillsDesc,
        points: 200,
        isCompleted: false,
        imageUrl: "assets/images/new_skills.jpg",
      ),
      Challenge(
        title: l10n.complimentsTitle,
        description: l10n.complimentsDesc,
        points: 140,
        isCompleted: false,
        imageUrl: "assets/images/compliments.jpg",
      ),
      Challenge(
        title: l10n.loveLettersTitle,
        description: l10n.loveLettersDesc,
        points: 180,
        isCompleted: false,
        imageUrl: "assets/images/love_letters.jpg",
      ),
      Challenge(
        title: l10n.firstDateRecreationTitle,
        description: l10n.firstDateRecreationDesc,
        points: 220,
        isCompleted: false,
        imageUrl: "assets/images/first_date.jpg",
      ),
      Challenge(
        title: l10n.tasteTestTitle,
        description: l10n.tasteTestDesc,
        points: 150,
        isCompleted: false,
        imageUrl: "assets/images/taste_test.jpg",
      ),
      Challenge(
        title: l10n.deepQuestionsTitle,
        description: l10n.deepQuestionsDesc,
        points: 190,
        isCompleted: false,
        imageUrl: "assets/images/deep_questions.jpg",
      ),
      Challenge(
        title: l10n.gratitudeTitle,
        description: l10n.gratitudeDesc,
        points: 170,
        isCompleted: false,
        imageUrl: "assets/images/gratitude.jpg",
      ),
      Challenge(
        title: l10n.futurePlanTitle,
        description: l10n.futurePlanDesc,
        points: 230,
        isCompleted: false,
        imageUrl: "assets/images/future_plan.jpg",
      ),
      Challenge(
        title: l10n.volunteerTitle,
        description: l10n.volunteerDesc,
        points: 240,
        isCompleted: false,
        imageUrl: "assets/images/volunteer.jpg",
      ),
      Challenge(
        title: l10n.donationTitle,
        description: l10n.donationDesc,
        points: 130,
        isCompleted: false,
        imageUrl: "assets/images/donation.jpg",
      ),
      Challenge(
        title: l10n.accentTitle,
        description: l10n.accentDesc,
        points: 120,
        isCompleted: false,
        imageUrl: "assets/images/accent.jpg",
      ),
      Challenge(
        title: l10n.roleSwapTitle,
        description: l10n.roleSwapDesc,
        points: 180,
        isCompleted: false,
        imageUrl: "assets/images/role_swap.jpg",
      ),
      Challenge(
        title: l10n.oppositeDayTitle,
        description: l10n.oppositeDayDesc,
        points: 160,
        isCompleted: false,
        imageUrl: "assets/images/opposite_day.jpg",
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    final challenges = getChallenges(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                padding: EdgeInsets.all(16),
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  final heightFactor = index % 2 == 0 ? 1.0 : 1.2;
                  return Transform.scale(
                    scale: 1.0,
                    child: ChallengeCard(
                      challenge: challenges[index],
                      heightFactor: heightFactor,
                    ),
                  );
                },
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
            l10n.coupleChallenges,
            style: GoogleFonts.lato(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: Color(0xFFE91C40), size: 20),
                SizedBox(width: 4),
                Text(
                  '83 pts',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE91C40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}