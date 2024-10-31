import 'package:flutter/material.dart';
import 'package:weatherapp/data/repositories/weather_repository.dart';
import 'package:weatherapp/presentation/widgets/search_bar.dart';
import 'package:weatherapp/presentation/widgets/weather_card.dart';
import 'package:weatherapp/data/models/weather_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherRepository _weatherRepository = WeatherRepository();
  bool isLoading = false;
  WeatherData? weatherData;
  String? errorMessage;

  Future<void> _getWeatherData(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final location = await _weatherRepository.getLocation(city);
      final weather = await _weatherRepository.getWeather(location);

      setState(() {
        weatherData = weather;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomSearchBar(onSearch: _getWeatherData),
              const SizedBox(height: 32),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (errorMessage != null)
                Center(
                  child: Text(
                    'Error: $errorMessage',
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else if (weatherData != null)
                WeatherCard(weather: weatherData!),
            ],
          ),
        ),
      ),
    );
  }
}
