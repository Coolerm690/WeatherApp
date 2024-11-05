import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _favoriteCitiesKey = 'favoriteCities';

  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteCitiesKey) ?? [];
  }

  Future<void> addFavoriteCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteCities = await getFavoriteCities();
    favoriteCities.add(city);
    await prefs.setStringList(_favoriteCitiesKey, favoriteCities);
  }

  Future<void> removeFavoriteCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteCities = await getFavoriteCities();
    favoriteCities.remove(city);
    await prefs.setStringList(_favoriteCitiesKey, favoriteCities);
  }
}
