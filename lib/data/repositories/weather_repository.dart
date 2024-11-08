import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/core/constants/api_constants.dart';
import 'package:weatherapp/data/models/weather_data.dart';
import 'package:weatherapp/data/models/location_data.dart';

class WeatherRepository {
  Future<LocationData> getLocation(String city) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.geocodingUrl}/search?name=$city&count=1'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to find city');
    }

    final data = json.decode(response.body);
    if (data['results'] == null || data['results'].isEmpty) {
      throw Exception('City not found');
    }

    return LocationData.fromJson(data['results'][0]);
  }

  Future<WeatherData> getWeather(LocationData location) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/forecast?latitude=${location.latitude}'
          '&longitude=${location.longitude}&current=temperature_2m,'
          'relative_humidity_2m,weather_code,wind_speed_10m'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get weather data');
    }

    return WeatherData.fromJson(
      json.decode(response.body),
      location.name,
    );
  }

  Future<List<double>> getHourlyTemperature(
      double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m'),
    );

    if (response.statusCode != 200) {
      throw Exception('Informazioni meteo non disponibili');
    }

    final data = json.decode(response.body);
    final hourly = data['hourly']['temperature_2m'];

    return List<double>.from(hourly.map((temp) => temp.toDouble()));
  }
}
