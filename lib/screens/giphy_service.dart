// lib/services/giphy_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class GiphyService {
  final String apiKey = 'ekW26qq2jC2nhgGlUpmfNKqxGYBtnAfJ';

  Future<List<String>> fetchGifs(String searchTerm) async {
    final url =
        'https://api.giphy.com/v1/gifs/search?api_key=$apiKey&q=$searchTerm&limit=10';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> gifUrls = [];

      for (var gif in data['data']) {
        gifUrls.add(gif['images']['fixed_height']['url']);
      }

      return gifUrls;
    } else {
      throw Exception('Failed to load GIFs');
    }
  }
}
