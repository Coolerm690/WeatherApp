import 'package:flutter/material.dart';

class FavoriteCitiesScreen extends StatelessWidget {
  final List<String> favoriteCities;

  const FavoriteCitiesScreen({Key? key, required this.favoriteCities})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Città Preferite'),
      ),
      body: ListView.builder(
        itemCount: favoriteCities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteCities[index]),
            // Puoi aggiungere ulteriori dettagli sulla città qui
          );
        },
      ),
    );
  }
}
