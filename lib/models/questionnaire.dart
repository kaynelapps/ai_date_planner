import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Question {
  final String question;
  final List<String> options;

  Question({required this.question, required this.options});
}

class Questionnaire {
  int _currentQuestionIndex = 0;
  final List<String> _answers = [];
  List<Question> _questions = [];
  int get currentQuestionIndex => _currentQuestionIndex;
  List<Question> getQuestions(BuildContext context) {
    return [
      Question(
        question: AppLocalizations.of(context)!.question1,
        options: [
          AppLocalizations.of(context)!.question1_option1,
          AppLocalizations.of(context)!.question1_option2,
          AppLocalizations.of(context)!.question1_option3,
          AppLocalizations.of(context)!.question1_option4,
          AppLocalizations.of(context)!.question1_option5,
          AppLocalizations.of(context)!.question1_option6,
          AppLocalizations.of(context)!.question1_option7,
        ],
      ),
      Question(
        question: AppLocalizations.of(context)!.question2,
        options: [
          AppLocalizations.of(context)!.question2_option1,
          AppLocalizations.of(context)!.question2_option2,
          AppLocalizations.of(context)!.question2_option3,
          AppLocalizations.of(context)!.question2_option4,
          AppLocalizations.of(context)!.question2_option5,
        ],
      ),
      Question(
        question: AppLocalizations.of(context)!.question3,
        options: [
          AppLocalizations.of(context)!.question3_option1,
          AppLocalizations.of(context)!.question3_option2,
          AppLocalizations.of(context)!.question3_option3,
        ],
      ),
      Question(
        question: AppLocalizations.of(context)!.question4,
        options: [
          AppLocalizations.of(context)!.question4_option1,
          AppLocalizations.of(context)!.question4_option2,
          AppLocalizations.of(context)!.question4_option3,
          AppLocalizations.of(context)!.question4_option4,
        ],
      ),
      Question(
        question: AppLocalizations.of(context)!.question5,
        options: [
          AppLocalizations.of(context)!.question5_option1,
          AppLocalizations.of(context)!.question5_option2,
        ],
      ),
      Question(
        question: AppLocalizations.of(context)!.question6,
        options: [
          AppLocalizations.of(context)!.question6_option1,
          AppLocalizations.of(context)!.question6_option2,
          AppLocalizations.of(context)!.question6_option3,
          AppLocalizations.of(context)!.question6_option4,
        ],
      ),
    ];
  }



  double get progress =>
      _questions.isEmpty ? 0 : (_currentQuestionIndex + 1) / _questions.length;

  void initializeQuestions(BuildContext context) {
    _questions = getQuestions(context);
  }

  Question get currentQuestion => _questions[_currentQuestionIndex];

  void answerCurrentQuestion(String answer) {

  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    }
  }

  bool isComplete() => _currentQuestionIndex >= _questions.length;

  List<String> get answers => _answers;

  List<Question> get questions => _questions;
}
