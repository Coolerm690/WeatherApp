import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/data/models/favorite_city.dart';
import 'weather_repository.dart';

class FavoritesRepository {
  static const String _favoritesKey = 'favorite_cities';
  final WeatherRepository _weatherRepository = WeatherRepository();

  Future<List<FavoriteCity>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteCities = prefs.getStringList(_favoritesKey) ?? [];

    List<FavoriteCity> favoriteCityData = [];
    for (String cityName in favoriteCities) {
      try {
        final location = await _weatherRepository.getLocation(cityName);
        final weather = await _weatherRepository.getWeather(location);
        favoriteCityData
            .add(FavoriteCity(cityName: cityName, weatherData: weather));
      } catch (e) {
        print('Errore nel recupero dei dati meteo per $cityName: $e');
      }
    }
    return favoriteCityData;
  }

  Future<void> addFavoriteCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteCities = prefs.getStringList(_favoritesKey) ?? [];
    if (!favoriteCities.contains(cityName)) {
      favoriteCities.add(cityName);
      await prefs.setStringList(_favoritesKey, favoriteCities);
    }
  }

  Future<void> removeFavoriteCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteCities = prefs.getStringList(_favoritesKey) ?? [];
    favoriteCities.remove(cityName);
    await prefs.setStringList(_favoritesKey, favoriteCities);
  }
}
