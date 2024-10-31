import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class WeatherUtils {
  static Widget getWeatherAnimation(int code) {
    switch (code) {
      case 0:
        return Lottie.asset('assets/lottie/sunny.json');

      case 1:
      case 2:
        return Lottie.asset('assets/lottie/partly.json');
      case 3:
        return Lottie.asset('assets/lottie/cloudy.json');
      case 61:
      case 63:
      case 65:
        return Lottie.asset('assets/lottie/partly.json');
      case 71:
      case 73:
      case 75:
        return Lottie.asset('assets/lottie/snow.json');
      case 95:
        return Lottie.asset('assets/lottie/thunderstorm.json');
      default:
        return Lottie.asset('assets/lottie/unknown.json');
    }
  }

  static String getWeatherCondition(int code) {
    switch (code) {
      case 0:
        return 'Cielo sereno';
      case 1:
        return 'Prevalentemente sereno';
      case 2:
        return 'Parzialmente nuvoloso';
      case 3:
        return 'Coperto';
      case 45:
        return 'Nebbia';
      case 48:
        return 'Nebbia da galaverna';
      case 51:
        return 'Pioviggine leggera';
      case 53:
        return 'Pioviggine moderata';
      case 55:
        return 'Pioviggine densa';
      case 61:
        return 'Pioggia leggera';
      case 63:
        return 'Pioggia moderata';
      case 65:
        return 'Pioggia intensa';
      case 71:
        return 'Neve leggera';
      case 73:
        return 'Neve moderata';
      case 75:
        return 'Neve intensa';
      case 80:
        return 'Rovesci leggeri';
      case 81:
        return 'Rovesci moderati';
      case 82:
        return 'Rovesci violenti';
      case 85:
        return 'Rovesci di neve leggera';
      case 86:
        return 'Rovesci di neve intensa';
      case 95:
        return 'Temporale';
      default:
        return 'Sconosciuto';
    }
  }
}
