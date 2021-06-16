import 'package:flutter/material.dart';
import 'package:weatherapp/Model/WeatherIcon/WeatherIconClasses.dart';

class WeatherIcon {
  int id;
  final iconPath = "assets/weatherIcon/day/";
  final fileExtension = ".png";

  WeatherIcon({required this.id});

  String getWeatherIcon() {
    switch (this.id ~/ 100) {
      case ThunderStorm.id:
        return this.iconPath +
            _getIcon(ThunderStorm.defaultIcon, ThunderStorm.icons) +
            this.fileExtension;
      case Drizzle.id:
        return this.iconPath +
            _getIcon(Drizzle.defaultIcon, Drizzle.icons) +
            this.fileExtension;
      case Rain.id:
        return this.iconPath +
            _getIcon(Rain.defaultIcon, Rain.icons) +
            this.fileExtension;
      case Snow.id:
        return this.iconPath +
            _getIcon(Snow.defaultIcon, Snow.icons) +
            this.fileExtension;
      case Atmosphere.id:
        return this.iconPath +
            _getIcon(Atmosphere.defaultIcon, Atmosphere.icons) +
            this.fileExtension;
      case CloudClear.id:
        return this.iconPath +
            _getIcon(CloudClear.defaultIcon, CloudClear.icons) +
            this.fileExtension;
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
