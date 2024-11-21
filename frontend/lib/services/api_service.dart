import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<Map<String, dynamic>> fetchPlaylist(
      String exercise, String time) async {
    final url = Uri.parse(
        '$baseUrl/auth/get_multiple_tracks/?exercise=$exercise&time=$time');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load playlist');
    }
  }
}