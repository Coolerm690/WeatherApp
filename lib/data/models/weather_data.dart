class WeatherData {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final String cityName;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.cityName,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json, String city) {
    final current = json['current'];
    return WeatherData(
      temperature: current['temperature_2m'],
      humidity: current['relative_humidity_2m'],
      windSpeed: current['wind_speed_10m'],
      weatherCode: current['weather_code'],
      cityName: city,
    );
  }
}
