import 'dart:convert';
import 'package:http/http.dart' as http;

class Weather {
  final String apiKey = '991f355fe65178914a9eae67707041c7';

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    final url =
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  Future<List<dynamic>> getForecast(String cityName) async {
    final url =
        'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final forecastData = jsonData['list'];
      return forecastData;
    } else {
      throw Exception('Failed to fetch forecast data');
    }
  }
}
