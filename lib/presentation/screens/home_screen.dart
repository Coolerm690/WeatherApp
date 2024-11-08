import 'package:flutter/material.dart';
import 'package:weatherapp/data/models/weather_data.dart';
import 'package:weatherapp/data/repositories/weather_repository.dart';
import 'package:weatherapp/presentation/widgets/search_bar.dart';
import 'package:weatherapp/presentation/widgets/weather_card.dart';
import 'favorite_cities_screen.dart';
import 'package:weatherapp/data/models/shared_preferences_service.dart'; // Importa il servizio SharedPreferences
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherRepository _weatherRepository = WeatherRepository();
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  bool isLoading = false;
  WeatherData? weatherData;
  String? errorMessage;
  List<String> favoriteCities = [];
  List<double> hourlyTemperatures = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteCities();
  }

  Future<void> _loadFavoriteCities() async {
    favoriteCities = await _sharedPreferencesService.getFavoriteCities();
    setState(() {});
  }

  Future<void> _getWeatherData(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final location = await _weatherRepository.getLocation(city);
      final weather = await _weatherRepository.getWeather(location);

      final hourlyTemps = await _weatherRepository.getHourlyTemperature(
          location.latitude, location.longitude);

      setState(() {
        weatherData = weather;
        hourlyTemperatures = hourlyTemps;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _toggleFavorite(String city) async {
    if (favoriteCities.contains(city)) {
      await _sharedPreferencesService.removeFavoriteCity(city);
      favoriteCities.remove(city);
    } else {
      await _sharedPreferencesService.addFavoriteCity(city);
      favoriteCities.add(city);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomSearchBar(onSearch: _getWeatherData),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoriteCitiesScreen(
                            favoriteCities: favoriteCities),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      SizedBox(width: 12),
                      Icon(Icons.star, color: Colors.amber),
                      Text('   Città Preferite'),
                    ],
                  ),
                ),
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
                  WeatherCard(
                    weather: weatherData!,
                    favoriteCities: favoriteCities,
                    toggleFavorite: _toggleFavorite,
                  ),
                const SizedBox(height: 32),
                // Grafico della temperatura oraria
                if (hourlyTemperatures.isNotEmpty)
                  SizedBox(
                    height: 250, // Imposta un'altezza fissa per il grafico
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(hourlyTemperatures.length,
                                (index) {
                              return FlSpot(
                                  index.toDouble(), hourlyTemperatures[index]);
                            }),
                            isCurved: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
