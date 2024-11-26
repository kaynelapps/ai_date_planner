import 'package:profanity_filter/profanity_filter.dart';

class ContentFilterService {
  final ProfanityFilter _filter = ProfanityFilter();

  String filterContent(String content) {
    return _filter.censor(content);
  }

  bool containsProfanity(String content) {
    return _filter.hasProfanity(content);
  }
}