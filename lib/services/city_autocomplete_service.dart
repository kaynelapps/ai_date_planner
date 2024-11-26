import 'package:http/http.dart' as http;
import 'dart:convert';

class CityAutocompleteService {
  final String baseUrl = 'http://geodb-free-service.wirefreethought.com/v1/geo/cities';

  Future<List<String>> getCitySuggestions(String input) async {
    final url = Uri.parse('$baseUrl?namePrefix=$input&limit=5&sort=-population');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cities = data['data'] as List<dynamic>;
        return cities.map((city) => "${city['name']}, ${city['country']}").toList();
      } else {
        throw Exception('Failed to load city suggestions');
      }
    } catch (e) {
      print('Error in getCitySuggestions: $e');
      rethrow;
    }
  }
}