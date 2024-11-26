class DateIdeasRepository {
  static final Map<String, List<String>> _dateIdeas = {
    'energetic_energetic': [
      'dateIdea_adventurePark',
      'dateIdea_danceClass',
      'dateIdea_rockClimbing',
      'dateIdea_bikeRidePicnic',
      'dateIdea_escapeRoom',
    ],
    'energetic_calm': [
      'dateIdea_cookingClass',
      'dateIdea_artGallery',
      'dateIdea_sunsetHike',
      'dateIdea_kayaking',
      'dateIdea_boardGameCafe',
    ],
    'calm_calm': [
      'dateIdea_stargazingPicnic',
      'dateIdea_spaDayy',
      'dateIdea_wineTasting',
      'dateIdea_bookstoreCafe',
      'dateIdea_yoga',
    ],
    'stressed_any': [
      'dateIdea_meditation',
      'dateIdea_natureWalk',
      'dateIdea_couplesMassage',
      'dateIdea_musicConcert',
      'dateIdea_potteryClass',
    ],
    'excited_any': [
      'dateIdea_mysteryDate',
      'dateIdea_foodTour',
      'dateIdea_amusementPark',
      'dateIdea_comedyShow',
      'dateIdea_karaoke',
    ],
    'tired_any': [
      'dateIdea_movieMarathon',
      'dateIdea_scenicDrive',
      'dateIdea_relaxingPicnic',
      'dateIdea_bookReading',
      'dateIdea_stargazing',
    ],
    'default': [
      'dateIdea_newRestaurant',
      'dateIdea_museum',
      'dateIdea_cookingClass2',
      'dateIdea_natureWalk2',
      'dateIdea_localEvent',
    ],
  };

  static List<String> getDateIdeas(String mood1, String mood2) {
    final key = _getCombinationKey(mood1, mood2);
    return _dateIdeas[key] ?? _dateIdeas['default']!;
  }

  static String _getCombinationKey(String mood1, String mood2) {
    if (mood1 == 'Stressed' || mood2 == 'Stressed') return 'stressed_any';
    if (mood1 == 'Excited' || mood2 == 'Excited') return 'excited_any';
    if (mood1 == 'Tired' || mood2 == 'Tired') return 'tired_any';

    if (mood1 == 'Energized' && mood2 == 'Energized') return 'energetic_energetic';
    if ((mood1 == 'Energized' && mood2 == 'Calm') || (mood1 == 'Calm' && mood2 == 'Energized')) return 'energetic_calm';
    if (mood1 == 'Calm' && mood2 == 'Calm') return 'calm_calm';

    return 'default';
  }
}
