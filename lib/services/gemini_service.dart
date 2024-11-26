import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:soulplan_ai_fun_date_ideas/models/questionnaire.dart';
import 'package:soulplan_ai_fun_date_ideas/repositories/date_ideas_repository.dart';
import 'package:soulplan_ai_fun_date_ideas/services/date_idea_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) throw Exception('GEMINI_API_KEY not found in environment variables');
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  Future<String?> regenerateDescription(String suggestion, String language) async {
    final title = suggestion.split('\n')[0];

    final prompt = '''
Generate a detailed description in $language for the following date idea: "$title"

Include:
1. An engaging introduction (2-3 sentences)
2. A step-by-step guide (5-6 steps)
3. How to accommodate different preferences
4. 3-4 special touches to make it memorable
5. 3 conversation topics or bonding activities
6. Required preparations
7. 2-3 adaptation tips

Format the response with clear section headers and detailed content under each section.
''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final description = response.text;

      if (description != null && description.isNotEmpty) {
        return '$title\n$description';
      }
      return null;
    } catch (e) {
      print('Error regenerating description: $e');
      return null;
    }
  }

  Future<List<String>> getDateSuggestions(
      Questionnaire user,
      Questionnaire partner,
      {required String language}) async {

    final userSentiment = await analyzeSentiment(user);
    final partnerSentiment = await analyzeSentiment(partner);
    final combinedSentiment = _combineSentiments(userSentiment, partnerSentiment);

    final userProfile = _createProfile(user);
    final partnerProfile = _createProfile(partner);

    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';

    final safetyPrompt = '''
As a relationship expert, design 3 enriching date experiences in $languageCode that focus on connection and shared joy:

Your Profile:
${userProfile.join('\n')}
Your Sentiment: ${json.encode(userSentiment)}

Your Partner's Profile:
${partnerProfile.join('\n')}
Your Partner's Sentiment: ${json.encode(partnerSentiment)}

Combined Sentiment:
${json.encode(combinedSentiment)}

For each suggestion, include:
1. A creative title
2. A detailed plan with:
   - Warm introduction (2-3 sentences)
   - Step-by-step guide (5-6 steps)
   - Personalization for both partners
   - Special moments to create memories
   - Engaging conversation starters
   - Preparation checklist
   - Flexibility options

Format as:
1. [Title]
[Detailed description with all elements, minimum 200 words]

2. [Next Title]
[Next detailed description]
... (continue for all 5)

Focus on wholesome activities that strengthen bonds through shared experiences.
''';

    try {
      final content = [Content.text(safetyPrompt)];
      final response = await _model.generateContent(content);
      var suggestions = _parseDateSuggestions(response.text ?? '');

      if (suggestions.isEmpty) {
        return _getFallbackDateIdeas(user, partner);
      }

      return suggestions.take(3).toList();
    } catch (e) {
      print('Error generating date suggestions: $e');
      return _getFallbackDateIdeas(user, partner);
    }
  }




  Future<String> getAtHomeDateAdvice(String suggestion, String language) async {
    final prompt = '''
    As an AI dating expert, provide detailed advice in $language for an at-home date based on the following suggestion: "$suggestion"

    Consider the following aspects:
    1. Adaptability: Suggest ways to adjust the activities based on energy levels and moods.
    2. Balance: Include both active and relaxing elements in the date.
    3. Communication: Incorporate opportunities for both conversation and comfortable silences.
    4. Personalization: Offer ideas to tailor the experience to each partner's preferences.
    5. Resource utilization: Focus on activities that can be done with items typically found at home.

    Structure your response as follows:

    #  : [Restate or adapt the suggestion for an at-home setting]

    ## Description
    [Brief, engaging description of the at-home date idea]

    ## Specific Activities
    1. [First activity]
    2. [Second activity]
    3. [Third activity]
    4. [Fourth activity]
    5. [Fifth activity]

    ## Tips to Make It Special
    - [First tip]
    - [Second tip]
    - [Third tip]
    - [Fourth tip]
    - [Fifth tip]

    ## Adaptations
    - For different energy levels: [Suggestion]
    - For varying moods: [Suggestion]
    - For conversation preferences: [Suggestion]

    Ensure your advice is creative, romantic, and tailored to make the at-home date memorable and enjoyable for both partners, regardless of their current states and without relying on external venues or services.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Unable to generate advice.';
    } catch (e) {
      print('Error generating at-home date advice: $e');
      return 'Error: Unable to generate advice. Please try again later.';
    }
  }

  List<String> _parseDateSuggestions(String responseText) {
    final suggestions = <String>[];
    final regex = RegExp(r'(\d+\.\s*.*?)(?=\n\d+\.|$)', dotAll: true);
    final matches = regex.allMatches(responseText);

    for (final match in matches) {
      final suggestion = match.group(1)?.trim() ?? '';
      if (suggestion.isNotEmpty) {
        final parts = suggestion.split('\n');
        if (parts.length > 1) {
          final title = parts[0].replaceFirst(RegExp(r'^\d+\.\s*'), '');
          final description = parts.sublist(1).join('\n').trim();
          suggestions.add('$title\n\n$description');
        } else {
          suggestions.add(suggestion);
        }
      }
    }

    return suggestions;
  }

  List<String> _getMoodBasedFallbackIdeas(Questionnaire user, Questionnaire partner) {
    String userMood = _getSimplifiedMood(user);
    String partnerMood = _getSimplifiedMood(partner);
    List<String> ideas = DateIdeasRepository.getDateIdeas(userMood, partnerMood);
    return ideas;
  }

  String _getSimplifiedMood(Questionnaire questionnaire) {
    Map<String, List<String>> moodKeywords = {
      'Energized': ['energetic', 'active', 'lively', 'enthusiastic', 'vigorous'],
      'Calm': ['relaxed', 'peaceful', 'tranquil', 'serene', 'composed'],
      'Stressed': ['anxious', 'worried', 'tense', 'overwhelmed', 'pressured'],
      'Excited': ['thrilled', 'eager', 'animated', 'elated', 'jubilant'],
      'Tired': ['exhausted', 'fatigued', 'weary', 'drained', 'sleepy']
    };

    Map<String, int> moodCounts = {
      'Energized': 0,
      'Calm': 0,
      'Stressed': 0,
      'Excited': 0,
      'Tired': 0
    };

    for (String answer in questionnaire.answers) {
      String lowerAnswer = answer.toLowerCase();
      for (var entry in moodKeywords.entries) {
        if (entry.value.any((keyword) => lowerAnswer.contains(keyword))) {
          moodCounts[entry.key] = (moodCounts[entry.key] ?? 0) + 1;
        }
      }
    }

    String dominantMood = moodCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return moodCounts[dominantMood]! > 0 ? dominantMood : 'Calm';
  }

  List<String> _getFallbackDateIdeas(Questionnaire user, Questionnaire partner) {
    final userMood = user.answers[0];
    final partnerMood = partner.answers[0];
    List<String> repoIdeas = DateIdeasRepository.getDateIdeas(userMood, partnerMood);
    List<String> enhancedIdeas = repoIdeas.map((idea) {
      List<String> categories = DateIdeaService.categorizeDateIdea(idea);
      List<String> placeTypes = DateIdeaService.getRelevantPlaceTypes(categories);
      return "$idea (${categories.join(', ')}) - Suggested places: ${placeTypes.take(3).join(', ')}";
    }).toList();

    return enhancedIdeas;
  }

  Map<String, dynamic> _combineSentiments(Map<String, dynamic> sentiment1, Map<String, dynamic> sentiment2) {
    final combinedMood = _averageMood(
        sentiment1['overallMood'] as String? ?? 'neutral',
        sentiment2['overallMood'] as String? ?? 'neutral'
    );
    final combinedEmotions = [
      ...(sentiment1['dominantEmotions'] as List<dynamic>? ?? []),
      ...(sentiment2['dominantEmotions'] as List<dynamic>? ?? [])
    ].whereType<String>().toSet().toList();
    final combinedPatterns = [
      ...(sentiment1['notablePatterns'] as List<dynamic>? ?? []),
      ...(sentiment2['notablePatterns'] as List<dynamic>? ?? [])
    ].whereType<String>().toSet().toList();
    final combinedScore = ((sentiment1['positivityScore'] as num? ?? 5) + (sentiment2['positivityScore'] as num? ?? 5)) / 2;

    return {
      'overallMood': combinedMood,
      'dominantEmotions': combinedEmotions,
      'notablePatterns': combinedPatterns,
      'positivityScore': combinedScore,
    };
  }

  String _averageMood(String? mood1, String? mood2) {
    final moodMap = {
      'very negative': 1,
      'negative': 2,
      'neutral': 3,
      'positive': 4,
      'very positive': 5,
    };

    final score1 = moodMap[mood1?.toLowerCase() ?? 'neutral'] ?? 3;
    final score2 = moodMap[mood2?.toLowerCase() ?? 'neutral'] ?? 3;
    final averageScore = (score1 + score2) / 2;

    if (averageScore < 1.5) return 'very negative';
    if (averageScore < 2.5) return 'negative';
    if (averageScore < 3.5) return 'neutral';
    if (averageScore < 4.5) return 'positive';
    return 'very positive';
  }

  List<String> _createProfile(Questionnaire q) {
    final profile = <String>[];

    // Make sure we don't exceed the available answers
    for (int i = 0; i < q.answers.length; i++) {
      if (i < q.questions.length) {
        profile.add('${q.questions[i].question}: ${q.answers[i]}');
      }
    }
    return profile;
  }


  Future<Map<String, dynamic>> analyzeSentiment(Questionnaire questionnaire) async {
    final content = [Content.text('''
      Analyze the sentiment and emotions in the following responses:
      ${questionnaire.answers.map((answer) => "- $answer").join("\n")}

      Provide a summary of the overall mood, dominant emotions, and any notable patterns.
      Also, rate the overall positivity on a scale of 1-10.

      Format the response as JSON with the following structure:
      {
               "overallMood": "string",
        "dominantEmotions": ["string"],
        "notablePatterns": ["string"],
        "positivityScore": number
      }
    ''')];

    try {
      final response = await _model.generateContent(content);
      final jsonResponse = json.decode(response.text ?? '{}');
      return jsonResponse;
    } catch (e) {
      print('Error analyzing sentiment: $e');
      return {};
    }
  }
}

