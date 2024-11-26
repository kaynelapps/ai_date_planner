import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:soulplan_ai_fun_date_ideas/services/date_idea_service.dart';

class FoursquareService {
  final String _apiKey = 'fsq3y91Sksda2gg8YjVt+h6FD4F7Ad4eIUYVx6FhsZB6vGs=';
  final String baseUrl = 'https://api.foursquare.com/v3';

  Future<List<Map<String, dynamic>>> getPlaces(String destination) async {
    try {
      final url = Uri.parse('$baseUrl/places/search')
          .replace(queryParameters: {
        'near': destination,
        'limit': '20',
        'categories': '16000,10000,13000,12000',
      });

      final response = await http.get(
        url,
        headers: {
          'Authorization': _apiKey,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['results'].map((place) => {
          'name': place['name'],
          'description': place['description'] ?? '',
          'address': place['location']['formatted_address'],
          'category': place['categories'][0]['name'],
          'rating': place['rating'] ?? 0.0,
          'imageUrl': _getPhotoUrl(place['fsq_id']),
        }));
      }
    } catch (e) {
      print('Error fetching places for $destination: $e');
    }
    return [];
  }
  Future<String> _getPhotoUrl(String placeId) async {
    try {
      final url = Uri.parse('$baseUrl/places/$placeId/photos');
      final response = await http.get(
        url,
        headers: {
          'Authorization': _apiKey,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> photos = json.decode(response.body);
        if (photos.isNotEmpty) {
          final photo = photos[0];
          return '${photo['prefix']}original${photo['suffix']}';
        }
      }
    } catch (e) {
      print('Error fetching photo for place $placeId: $e');
    }
    return '';
  }

  Future<List<String>> getImageUrls(String destination, int count) async {
    final places = await getPlaces(destination);
    return places
        .where((place) => place['imageUrl'] != null && place['imageUrl'].isNotEmpty)
        .map((place) => place['imageUrl'] as String)
        .take(count)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getPlacesByDateIdea(String dateIdea, String destination) async {
    List<String> categories = DateIdeaService.categorizeDateIdea(dateIdea);
    String categoryIds = _mapCategoriesToFoursquareIds(categories);

    final url = Uri.parse('$baseUrl/places/search')
        .replace(queryParameters: {
      'near': destination,
      'limit': '20',
      'categories': categoryIds,
    });

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
        return List<Map<String, dynamic>>.from(data['results'].map((place) => {
          'name': place['name'],
          'description': place['description'] ?? '',
          'address': place['location']['formatted_address'],
          'category': place['categories'][0]['name'],
          'rating': place['rating'] ?? 0.0,
          'imageUrl': _getPhotoUrl(place['fsq_id']),
        }));
      }
    } catch (e) {
      print('Error fetching places for $destination: $e');
    }
    return [];
  }
  String _mapCategoriesToFoursquareIds(List<String> categories) {
    Map<String, String> categoryMapping = {
      'cultural': '10000,10027',
      'outdoor_activity': '16000',
      'food_experience': '13000',
      'shopping': '12000',
      'adventure': '10000,18000',
      'relaxation': '14000',
      'sports': '18000',
      'nightlife': '10032',
      'entertainment': '10035',
      'arts': '10025',
      'wellness': '14000',
      'education': '12052',
    };

    return categories
        .map((cat) => categoryMapping[cat] ?? '')
        .where((id) => id.isNotEmpty)
        .join(',');
  }

  Future<Map<String, dynamic>> getDestinationInfo(String destination) async {
    try {
      final url = Uri.parse('$baseUrl/places/search')
          .replace(queryParameters: {
        'near': destination,
        'limit': '1',
      });

      final response = await http.get(
        url,
        headers: {
          'Authorization': _apiKey,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final context = data['context'];
        return {
          'destinationId': context['geo_bounds']['circle']['center']['latitude'].toString() +
              ',' +
              context['geo_bounds']['circle']['center']['longitude'].toString(),
          'name': context['geo_bounds']['circle']['center']['name'],
          'latitude': context['geo_bounds']['circle']['center']['latitude'],
          'longitude': context['geo_bounds']['circle']['center']['longitude'],
        };
      }
    } catch (e) {
      print('Error fetching destination info for $destination: $e');
    }
    return {};
  }

  Future<Map<String, dynamic>> getWeather(String destination) async {
    try {
      final destInfo = await getDestinationInfo(destination);
      final lat = destInfo['latitude'];
      final lon = destInfo['longitude'];
      final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=YOUR_OPENWEATHER_API_KEY&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error fetching weather for $destination: $e');
    }
    return {};
  }
}
