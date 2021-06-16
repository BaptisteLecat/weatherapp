import 'package:flutter/material.dart';
import 'package:weatherapp/Model/WeatherIcon/WeatherIconClasses.dart';

class WeatherIcon {
  int id;

  WeatherIcon({required this.id});

  String getWeatherIcon() {
    switch (this.id ~/ 100) {
      case ThunderStorm.id:
        return _getIcon(ThunderStorm.defaultIcon, ThunderStorm.icons);
      case Drizzle.id:
        return _getIcon(Drizzle.defaultIcon, Drizzle.icons);
      case Rain.id:
        return _getIcon(Rain.defaultIcon, Rain.icons);
      case Snow.id:
        return _getIcon(Snow.defaultIcon, Snow.icons);
      case Atmosphere.id:
        return _getIcon(Atmosphere.defaultIcon, Atmosphere.icons);
      case CloudClear.id:
        return _getIcon(CloudClear.defaultIcon, CloudClear.icons);
      default:
        return "default";
    }
  }

  String _getIcon(String defaultIcon, Map icons) {
    String icon = defaultIcon;

    for (var key in icons.keys) {
      if (this.id == key) {
        icon = icons[key];
      }
    }

    return icon;
  }
}
