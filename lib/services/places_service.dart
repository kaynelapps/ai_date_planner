import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:soulplan_ai_fun_date_ideas/services/date_idea_service.dart';

class PlacesService {
  final String _apiKey = 'fsq3JhEN4LLgCWt+i6FKfBPchqf14i0c6TW0zoqCgSemof0=';
  final String baseUrl = 'https://api.foursquare.com/v3/places';

  String _getQueryFromDateIdea(String dateIdea) {
    if (dateIdea.startsWith('dateIdea_')) {
      final keywords = DateIdeaService.extractKeywords(dateIdea);
      return keywords.take(3).join(' ');
    }
    return dateIdea;
  }

  Future<List<Map<String, dynamic>>> getPlaces(String suggestion, String location, String price, String dateCategory) async {
    String searchQuery = _getQueryFromDateIdea(suggestion);
    bool isPriceSensitive = DateIdeaService.isPriceSensitiveActivity(searchQuery);
    bool isFree = price == 'Free';
    List<String> categories = DateIdeaService.categorizeDateIdea(searchQuery);
    String priceParam = isFree ? '' : '&price=${price.length}';

    if (categories.contains("scenic_activity") || categories.contains("walking")) {
      return _getSceniceOrWalkingPlaces(searchQuery, location, isFree);
    }

    String categoriesParam = _getCategoriesForSuggestion(searchQuery, isFree, dateCategory);
    final url = Uri.parse('$baseUrl/search?query=${isFree ? "free " : ""}$searchQuery&near=$location&sort=RELEVANCE&limit=50$priceParam$categoriesParam');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': _apiKey,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;
        return results.map((place) => _parsePlace(place, isFree, dateCategory)).where((place) => place != null).cast<Map<String, dynamic>>().toList();
      } else {
        throw Exception('Failed to load places: ${response.body}');
      }
    } catch (e) {
      print('Error in getPlaces: $e');
      rethrow;
    }
  }
  Future<List<Map<String, dynamic>>> _getSceniceOrWalkingPlaces(String suggestion, String location, bool isFree) async {
    final url = Uri.parse('$baseUrl/search?query=scenic spots&near=$location&sort=RELEVANCE&limit=50&categories=16000,26000');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': _apiKey,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;
        return results.map((place) => _parseSceniceOrWalkingPlace(place, suggestion)).where((place) => place != null).cast<Map<String, dynamic>>().toList();
      } else {
        throw Exception('Failed to load scenic places: ${response.body}');
      }
    } catch (e) {
      print('Error in _getSceniceOrWalkingPlaces: $e');
      rethrow;
    }
  }

  Map<String, dynamic>? _parsePlace(dynamic place, bool isFree, String dateCategory) {
    final category = place['categories'].isNotEmpty ? place['categories'][0]['name'] : 'N/A';
    if ((isFree && !_isLikelyFree(category)) || (!isFree && !_isPlaceSuitable(category, dateCategory))) {
      return null;
    }
    return {
      'id': place['fsq_id'],
      'name': place['name'],
      'address': place['location']['formatted_address'],
      'category': category,
      'price': place['price'] != null ? '\$' * place['price'] : 'N/A',
    };
  }

  Map<String, dynamic>? _parseSceniceOrWalkingPlace(dynamic place, String suggestion) {
    final category = place['categories'].isNotEmpty ? place['categories'][0]['name'] : 'N/A';
    if (!_isSceniceOrWalkingSuitable(category)) {
      return null;
    }
    return {
      'id': place['fsq_id'],
      'name': place['name'],
      'address': place['location']['formatted_address'],
      'category': category,
      'suggestion': suggestion,
    };
  }
  bool _isLikelyFree(String category) {
    List<String> freeCategories = [
      'Park', 'Beach', 'Hiking Trail', 'Playground', 'Garden',
      'Historic Site', 'Scenic Lookout', 'Monument', 'Plaza',
      'Outdoor', 'Trail', 'Waterfront', 'Pedestrian Plaza'
    ];
    return freeCategories.any((freeCategory) =>
        category.toLowerCase().contains(freeCategory.toLowerCase()));
  }

  bool _isPlaceSuitable(String placeCategory, String dateCategory) {
    Map<String, List<String>> suitableCategories = {
      'standup_comedy': ['Comedy Club', 'Theater', 'Performing Arts Venue'],
      'movie': ['Movie Theater', 'Cinema'],
      'dinner': ['Restaurant', 'Bistro', 'Cafe', 'Diner'],
      'outdoor_activity': ['Park', 'Hiking Trail', 'Beach', 'Garden', 'Outdoor'],
      'cultural': ['Museum', 'Art Gallery', 'Historical Site'],
      'adventure': ['Amusement Park', 'Sports Venue', 'Recreation Center'],
      'relaxation': ['Spa', 'Wellness Center', 'Yoga Studio'],
      'food_experience': ['Restaurant', 'Cooking School', 'Food Market']
    };

    List<String> suitable = suitableCategories[dateCategory] ?? [];
    return suitable.isEmpty || suitable.any((cat) => placeCategory.toLowerCase().contains(cat.toLowerCase()));
  }

  bool _isSceniceOrWalkingSuitable(String category) {
    List<String> suitableCategories = [
      'Park', 'Beach', 'Hiking Trail', 'Scenic Lookout', 'Garden',
      'Nature Preserve', 'Mountain', 'Waterfront', 'Plaza', 'Pedestrian Plaza'
    ];
    return suitableCategories.any((suitable) =>
        category.toLowerCase().contains(suitable.toLowerCase()));
  }

  String _getCategoriesForSuggestion(String suggestion, bool isFree, String dateCategory) {
    Map<String, String> categoryMap = {
      'standup_comedy': '10035,10024',
      'movie': '10024',
      'dinner': '13065',
      'outdoor_activity': '16000',
      'sports': '18000',
      'adventure': '10000,18000',
      'cultural': '10000,10027',
      'relaxation': '14000',
      'educational': '12000',
      'nightlife': '10032',
      'music': '10032,10028',
      'gaming': '18021',
      'water_activity': '16000,18000',
      'fitness': '18000,14000',
      'shopping': '17000',
      'animal_related': '19000',
      'adrenaline': '18000',
      'romantic': '13065,10000',
      'creative': '10000,12000',
      'technology': '18021,12000',
      'food_experience': '13000',
      'dance': '10032,14000',
      'spiritual': '12000',
      'literary': '12000',
      'seasonal': '10000',
      'scenic': '16000',
      'wellness': '14000',
      'social_cause': '12000',
      'transportation': '19000',
      'mystery': '10000,18021',
      'yoga': '14000',
      'go_kart': '18000',
      'hiking': '16000',
      'cinema': '10024'
    };

    String categories = categoryMap[dateCategory] ?? '';
    if (categories.isEmpty) {
      categories = isFree ? '16000' : '13065,10024,10035,10027,18021,13037,17000,10001';
    }
    return '&categories=$categories';
  }


  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final url = Uri.parse('$baseUrl/$placeId?fields=fsq_id,name,description,location,categories,photos,hours,price,rating,stats,website,tel');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': _apiKey,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parsePlaceDetails(data);
      } else {
        throw Exception('Failed to load place details: ${response.body}');
      }
    } catch (e) {
      print('Error in getPlaceDetails: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _parsePlaceDetails(Map<String, dynamic> data) {
    return {
      'id': data['fsq_id'],
      'name': data['name'],
      'description': data['description'] ?? 'No description available',
      'address': data['location']['formatted_address'],
      'category': data['categories'].isNotEmpty ? data['categories'][0]['name'] : 'N/A',
      'photos': (data['photos'] as List<dynamic>?)?.map((photo) =>
      '${photo['prefix']}original${photo['suffix']}'
      ).toList() ?? [],
      'price': data['price'] != null ? '\$' * data['price'] : 'N/A',
      'rating': data['rating']?.toDouble() ?? 0.0,
      'website': data['website'] ?? 'N/A',
      'phone': data['tel'] ?? 'N/A',
    };
  }
}
