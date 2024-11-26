import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soulplan_ai_fun_date_ideas/models/questionnaire.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/results_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/services/gemini_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/intermediate_screen.dart';
import 'package:soulplan_ai_fun_date_ideas/screens/loading_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestionnaireScreen extends StatefulWidget {
  @override

  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}



class _QuestionnaireScreenState extends State<QuestionnaireScreen> with SingleTickerProviderStateMixin {
  final Questionnaire _userQuestionnaire = Questionnaire();
  final Questionnaire _partnerQuestionnaire = Questionnaire();
  bool _isUserQuestionnaire = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Key _animatedTextKey = UniqueKey();
  bool _isPressed = false;
  String? _userGender;
  String? _partnerGender;

  final List<String> genderOptions = [
    'male',
    'female',
    'nonBinary',
    'transgender',
    'genderFluid',
    'genderQueer',
    'other',
    'preferNotToSay'
  ];
  String getTranslatedGender(BuildContext context, String genderKey) {
    switch (genderKey) {
      case 'male':
        return AppLocalizations.of(context)!.male;
      case 'female':
        return AppLocalizations.of(context)!.female;
      case 'nonBinary':
        return AppLocalizations.of(context)!.nonBinary;
      case 'transgender':
        return AppLocalizations.of(context)!.transgender;
      case 'genderFluid':
        return AppLocalizations.of(context)!.genderFluid;
      case 'genderQueer':
        return AppLocalizations.of(context)!.genderQueer;
      case 'other':
        return AppLocalizations.of(context)!.other;
      case 'preferNotToSay':
        return AppLocalizations.of(context)!.preferNotToSay;
      default:
        return genderKey;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          _isUserQuestionnaire
              ? AppLocalizations.of(context)!.yourQuestionnaire
              : AppLocalizations.of(context)!.partnerQuestionnaire,
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
      body: (_isUserQuestionnaire && _userGender == null) ||
          (!_isUserQuestionnaire && _partnerGender == null)
          ? _buildGenderSelection()
          : _buildQuestionnaireBody(),
    );

  }
  Widget _buildProgressIndicator() {
    final currentQuestionnaire = _isUserQuestionnaire ? _userQuestionnaire : _partnerQuestionnaire;
    final progress = currentQuestionnaire.progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${currentQuestionnaire.currentQuestionIndex + 1}',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E2E2E),
              ),
            ),
            AnimatedCounter(
              value: (progress * 100).toInt(),
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE91C40),
              ),
            ),
          ],
        ).animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.2, end: 0),

        SizedBox(height: 8),

        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: progress),
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          builder: (context, double value, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91C40)),
                minHeight: 8,
              ),
            );
          },
        ).animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.2, end: 0),
      ],
    );
  }

  Widget _buildQuestionCard(Questionnaire questionnaire) {
    return Container(
      padding: EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E2E2E),
            ),
            child: AnimatedTextKit(
              key: _animatedTextKey,
              animatedTexts: [
                TypewriterAnimatedText(
                  questionnaire.currentQuestion.question,
                  speed: Duration(milliseconds: 50),
                  curve: Curves.easeOut,
                ),
              ],
              totalRepeatCount: 1,
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(
      begin: -0.2,
      end: 0,
      duration: 600.ms,
      curve: Curves.easeOutCubic,
    );
  }
  Widget _buildAnswerOptions(Questionnaire questionnaire) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: questionnaire.currentQuestion.options.length,
        itemBuilder: (context, index) {
          return _buildAnswerCard(
            questionnaire.currentQuestion.options[index],
                () {
              HapticFeedback.lightImpact();
              questionnaire.answerCurrentQuestion(
                questionnaire.currentQuestion.options[index],
              );
              _handleQuestionChange();
            },
            index,
          );
        },
      ),
    );
  }

  Widget _buildAnswerCard(String answer, VoidCallback onTap, int index) {
    return _buildGestureDetector(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              answer,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2E2E2E),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      onTap,
    ).animate()
        .fadeIn(delay: (100 * index).ms)
        .slideY(
      begin: 0.2,
      end: 0,
      curve: Curves.easeOutCubic,
      duration: 600.ms,
    );
  }

  Widget _buildGenderSelection() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isUserQuestionnaire
                  ? AppLocalizations.of(context)!.selectYourGender
                  : AppLocalizations.of(context)!.selectPartnerGender,
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E2E2E),
              ),
            ).animate().fadeIn().slideY(),
            SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: genderOptions.length,
                itemBuilder: (context, index) {
                  return _buildAnswerCard(
                    getTranslatedGender(context, genderOptions[index]),
                        () {
                      setState(() {
                        if (_isUserQuestionnaire) {
                          _userGender = genderOptions[index];
                        } else {
                          _partnerGender = genderOptions[index];
                        }
                      });
                    },
                    index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionnaireBody() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressIndicator(),
            SizedBox(height: 24),
            _buildQuestionCard(_isUserQuestionnaire ? _userQuestionnaire : _partnerQuestionnaire),
            SizedBox(height: 32),
            _buildAnswerOptions(_isUserQuestionnaire ? _userQuestionnaire : _partnerQuestionnaire),
          ],
        ),
      ),
    );
  }

  Widget _buildGestureDetector(Widget child, VoidCallback onTap) {
    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: _handleTapCancel,
      onTap: onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: child,
      ),
    );
  }
  void _handleTapDown() {
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
  }

  void _handleTapUp() {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  void _handleQuestionChange() {
    _animationController.reverse().then((_) {
      setState(() {
        final currentQuestionnaire = _isUserQuestionnaire ? _userQuestionnaire : _partnerQuestionnaire;

        if (currentQuestionnaire.currentQuestionIndex == currentQuestionnaire.questions.length - 1) {
          if (_isUserQuestionnaire) {
            _showIntermediateScreen();
          } else {
            _submitQuestionnaires();
          }
          return;
        }

        currentQuestionnaire.nextQuestion();
        _animatedTextKey = UniqueKey();
      });
      _animationController.forward();
    });
  }




  void _showIntermediateScreen() {
    Navigator.push(
      context,
      CustomPageRoute(page: IntermediateScreen()),
    ).then((_) {
      setState(() {
        _isUserQuestionnaire = false;
        _animatedTextKey = UniqueKey();
      });
      _animationController.reset();
      _animationController.forward();
    });
  }
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userQuestionnaire.initializeQuestions(context);
    _partnerQuestionnaire.initializeQuestions(context);
    _startEntryAnimation();
  }



  void _startEntryAnimation() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _submitQuestionnaires() async {
    final locale = Localizations.localeOf(context).languageCode;

    Navigator.push(
      context,
      CustomPageRoute(
        page: LoadingScreen(
          suggestion: "Date ideas",
          priceRange: "Any",
          city: "Your city",
        ),
      ),
    );

    try {
      final geminiService = GeminiService();
      List<String> dateSuggestions = await geminiService.getDateSuggestions(
        _userQuestionnaire,
        _partnerQuestionnaire,
        language: locale,
      );

      if (dateSuggestions.isEmpty) {
        dateSuggestions = ['No suggestions available. Please try again.'];
      }

      Navigator.pushReplacement(
        context,
        CustomPageRoute(
          page: ResultsScreen(
            dateSuggestions: dateSuggestions,
            onRetry: () async {
              Navigator.push(
                context,
                CustomPageRoute(
                  page: LoadingScreen(
                    suggestion: "Date ideas",
                    priceRange: "Any",
                    city: "Your city",
                  ),
                ),
              );

              dateSuggestions = await geminiService.getDateSuggestions(
                _userQuestionnaire,
                _partnerQuestionnaire,
                language: locale,
              );

              Navigator.pop(context);
              return dateSuggestions;
            },
          ),
        ),
      );
    } catch (e) {
      print('Error generating suggestions: $e');
      Navigator.pop(context); // Remove loading screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating suggestions. Please try again.')),
      );
    }
  }

}

class CustomPageRoute extends PageRouteBuilder {
  final Widget page;

  CustomPageRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 500),
  );
}

class AnimatedCounter extends StatelessWidget {
  final int value;
  final TextStyle style;

  const AnimatedCounter({
    required this.value,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: IntTween(begin: 0, end: value),
      duration: Duration(milliseconds: 800),
      builder: (context, int value, child) {
        return Text(
          '$value%',
          style: style,
        );
      },
    );
  }
}
