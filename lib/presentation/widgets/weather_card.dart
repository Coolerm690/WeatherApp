import 'package:flutter/material.dart';
import 'package:weatherapp/data/models/weather_data.dart';
import 'package:weatherapp/utils/weather_utils.dart';
import 'package:weatherapp/presentation/widgets/weather_info_item.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData weather;

  const WeatherCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
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
                height: 200, // Altezza della Lottie animation
                width: 250,
                child: WeatherUtils.getWeatherAnimation(weather.weatherCode),
              ),
              const SizedBox(height: 0),
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
                  WeatherInfoItem(
                    icon: Icons.water_drop,
                    label: 'Umidità',
                    value: '${weather.humidity}%',
                  ),
                  WeatherInfoItem(
                    icon: Icons.air,
                    label: 'Vento',
                    value: '${weather.windSpeed} km/h',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
