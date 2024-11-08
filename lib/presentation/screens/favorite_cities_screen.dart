import 'package:flutter/material.dart';
import 'package:weatherapp/data/repositories/weather_repository.dart'; // Importa il repository
import 'package:weatherapp/data/models/weather_data.dart'; // Importa il modello WeatherData
import 'package:weatherapp/data/models/location_data.dart'; // Importa il modello LocationData

// Aggiungiamo una mappa di weatherCode a icone
class FavoriteCitiesScreen extends StatefulWidget {
  final List<String> favoriteCities;

  const FavoriteCitiesScreen({Key? key, required this.favoriteCities})
      : super(key: key);

  @override
  _FavoriteCitiesScreenState createState() => _FavoriteCitiesScreenState();
}

class _FavoriteCitiesScreenState extends State<FavoriteCitiesScreen> {
  late Future<List<Map<String, dynamic>>> citiesWithWeather;
  final WeatherRepository weatherRepository =
      WeatherRepository(); // Crea un'istanza del repository

  @override
  void initState() {
    super.initState();
    // Usa il metodo per ottenere i dati meteo per le città
    citiesWithWeather = _getCitiesWithWeather();
  }

  // Mappiamo i codici meteo alle icone
  Icon _getWeatherIcon(int weatherCode) {
    switch (weatherCode) {
      case 0: // Sole
        return const Icon(Icons.wb_sunny, color: Colors.orange);
      case 1: // Nuvole
        return const Icon(Icons.cloud, color: Colors.grey);
      case 2: // Pioggia leggera
        return const Icon(Icons.grain, color: Colors.blue);
      case 3: // Pioggia forte
        return const Icon(Icons.beach_access, color: Colors.blue);
      case 4: // Temporale
        return const Icon(Icons.flash_on, color: Colors.yellow);
      default:
        return const Icon(Icons.cloud, color: Colors.grey); // Nuvole di default
    }
  }

  // Metodo per ottenere i dati meteo e ordinarli per temperatura
  Future<List<Map<String, dynamic>>> _getCitiesWithWeather() async {
    List<Map<String, dynamic>> cities = [];

    for (String city in widget.favoriteCities) {
      try {
        // Recupera la posizione della città (latitudine, longitudine)
        LocationData location = await weatherRepository.getLocation(city);

        // Recupera i dati meteo per quella posizione
        WeatherData weather = await weatherRepository.getWeather(location);

        // Aggiungi la città e la sua temperatura alla lista
        cities.add({
          'name': city,
          'temperature':
              weather.temperature, // La temperatura è ottenuta da WeatherData
          'humidity': weather
              .humidity, // Puoi anche aggiungere altre informazioni, se necessario
          'windSpeed': weather.windSpeed,
          'weatherCode': weather.weatherCode, // Aggiungi anche il weatherCode
        });
      } catch (e) {
        // Gestisci gli errori (ad esempio, se la città non è trovata o errore di rete)
        print('Errore nel recupero del meteo per $city: $e');
      }
    }

    // Ordina la lista in base alla temperatura
    cities.sort((a, b) => a['temperature'].compareTo(b['temperature']));

    return cities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Città Preferite'),
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
                  leading: _getWeatherIcon(
                      city['weatherCode']), // Mostra l'icona meteo
                  title: Text(city['name']),
                  subtitle: Text('Temperatura: ${city['temperature']}°C\n'
                      'Umidità: ${city['humidity']}%\n'
                      'Vento: ${city['windSpeed']} km/h'),
                  onTap: () {
                    // Quando l'utente clicca su una città, mostriamo un altro schermo con dettagli meteo
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherDetailScreen(
                          cityName: city['name'],
                          temperature: city['temperature'],
                          weatherIcon: _getWeatherIcon(city['weatherCode']),
                          humidity: city['humidity'],
                          windSpeed: city['windSpeed'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Schermata dei dettagli del meteo
class WeatherDetailScreen extends StatelessWidget {
  final String cityName;
  final double temperature;
  final Icon weatherIcon;
  final int humidity;
  final double windSpeed;

  const WeatherDetailScreen({
    Key? key,
    required this.cityName,
    required this.temperature,
    required this.weatherIcon,
    required this.humidity,
    required this.windSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cityName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            weatherIcon,
            SizedBox(height: 20),
            Text('Temperatura: $temperature°C', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('Umidità: $humidity%', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Vento: $windSpeed km/h', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
