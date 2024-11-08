import 'package:flutter/material.dart';
import 'package:weatherapp/data/models/weather_data.dart';
import 'package:weatherapp/utils/weather_utils.dart';
import 'package:weatherapp/presentation/widgets/weather_info_item.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData weather;
  final List<String> favoriteCities;
  final Function toggleFavorite;

  const WeatherCard({
    Key? key,
    required this.weather,
    required this.favoriteCities,
    required this.toggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFavorite = favoriteCities.contains(weather.cityName);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                weather.cityName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.yellow,
                  size: 30,
                ),
                onPressed: () => toggleFavorite(weather.cityName),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 15,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: 250,
                  child: WeatherUtils.getWeatherAnimation(weather.weatherCode),
                ),
                const SizedBox(height: 16),
                Text(
                  '${weather.temperature.round()}°',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  WeatherUtils.getWeatherCondition(weather.weatherCode),
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: WeatherInfoItem(
                        icon: Icons.water_drop,
                        label: 'Umidità',
                        value: '${weather.humidity}%',
                      ),
                    ),
                    Flexible(
                      child: WeatherInfoItem(
                        icon: Icons.air,
                        label: 'Vento',
                        value: '${weather.windSpeed} km/h',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
