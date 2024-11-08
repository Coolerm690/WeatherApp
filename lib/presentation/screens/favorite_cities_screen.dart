import 'package:flutter/material.dart';
import 'package:weatherapp/data/repositories/weather_repository.dart';
import 'package:weatherapp/data/models/weather_data.dart';
import 'package:weatherapp/data/models/location_data.dart';

class FavoriteCitiesScreen extends StatefulWidget {
  final List<String> favoriteCities;

  const FavoriteCitiesScreen({Key? key, required this.favoriteCities})
      : super(key: key);

  @override
  _FavoriteCitiesScreenState createState() => _FavoriteCitiesScreenState();
}

class _FavoriteCitiesScreenState extends State<FavoriteCitiesScreen> {
  late Future<List<Map<String, dynamic>>> citiesWithWeather;
  final WeatherRepository weatherRepository = WeatherRepository();
  bool isSortedByTemperature = false;

  @override
  void initState() {
    super.initState();
    citiesWithWeather = _getCitiesWithWeather();
  }

  Icon _getWeatherIcon(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return const Icon(Icons.wb_sunny, color: Colors.orange);
      case 1:
        return const Icon(Icons.cloud, color: Colors.grey);
      case 2:
        return const Icon(Icons.grain, color: Colors.blue);
      case 3:
        return const Icon(Icons.beach_access, color: Colors.blue);
      case 4:
        return const Icon(Icons.flash_on, color: Colors.yellow);
      default:
        return const Icon(Icons.cloud, color: Colors.grey);
    }
  }

  Future<List<Map<String, dynamic>>> _getCitiesWithWeather() async {
    List<Map<String, dynamic>> cities = [];

    for (String city in widget.favoriteCities) {
      try {
        LocationData location = await weatherRepository.getLocation(city);
        WeatherData weather = await weatherRepository.getWeather(location);

        cities.add({
          'name': city,
          'temperature': weather.temperature,
          'humidity': weather.humidity,
          'windSpeed': weather.windSpeed,
          'weatherCode': weather.weatherCode,
        });
      } catch (e) {
        print('Errore nel recupero delle informazioni meteo per $city: $e');
      }
    }

    return cities;
  }

  void _toggleSortOrder() {
    setState(() {
      isSortedByTemperature = !isSortedByTemperature;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Città Preferite'),
        actions: [
          IconButton(
            icon: Icon(isSortedByTemperature
                ? Icons.sort_by_alpha
                : Icons.thermostat_outlined),
            onPressed: () {
              setState(() {
                citiesWithWeather = _getCitiesWithWeather().then((cities) {
                  cities.sort((a, b) => isSortedByTemperature
                      ? a['name'].compareTo(b['name'])
                      : a['temperature'].compareTo(b['temperature']));
                  return cities;
                });
                _toggleSortOrder();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: citiesWithWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nessuna città disponibile.'));
          } else {
            final cities = snapshot.data!;
            return ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                return ListTile(
                  leading: _getWeatherIcon(city['weatherCode']),
                  title: Text(city['name']),
                  subtitle: Text('Temperatura: ${city['temperature']}°C\n'
                      'Umidità: ${city['humidity']}%\n'
                      'Vento: ${city['windSpeed']} km/h'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
