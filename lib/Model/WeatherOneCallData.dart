// To parse this JSON data, do
//
//     final weatherOneCallData = weatherOneCallDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

WeatherOneCallData weatherOneCallDataFromJson(String str) =>
    WeatherOneCallData.fromJson(json.decode(str));

String weatherOneCallDataToJson(WeatherOneCallData data) =>
    json.encode(data.toJson());

class WeatherOneCallData {
  WeatherOneCallData({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.timezoneOffset,
    required this.hourly,
  });

  double lat;
  double lon;
  String timezone;
  int timezoneOffset;
  List<Hourly> hourly;

  factory WeatherOneCallData.fromJson(Map<String, dynamic> json) =>
      WeatherOneCallData(
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
        timezone: json["timezone"],
        timezoneOffset: json["timezone_offset"],
        hourly:
            List<Hourly>.from(json["hourly"].map((x) => Hourly.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
        "timezone": timezone,
        "timezone_offset": timezoneOffset,
        "hourly": List<dynamic>.from(hourly.map((x) => x.toJson())),
      };
}

class Hourly {
  Hourly({
    required this.dt,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.windGust,
    required this.weather,
    required this.pop,
  });

  int dt;
  double temp;
  double feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  double uvi;
  int clouds;
  int visibility;
  double windSpeed;
  int windDeg;
  double windGust;
  List<Weather> weather;
  double pop;

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        dt: json["dt"],
        temp: json["temp"].toDouble(),
        feelsLike: json["feels_like"].toDouble(),
        pressure: json["pressure"],
        humidity: json["humidity"],
        dewPoint: json["dew_point"].toDouble(),
        uvi: json["uvi"].toDouble(),
        clouds: json["clouds"],
        visibility: json["visibility"],
        windSpeed: json["wind_speed"].toDouble(),
        windDeg: json["wind_deg"],
        windGust: json["wind_gust"].toDouble(),
        weather:
            List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
        pop: json["pop"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "temp": temp,
        "feels_like": feelsLike,
        "pressure": pressure,
        "humidity": humidity,
        "dew_point": dewPoint,
        "uvi": uvi,
        "clouds": clouds,
        "visibility": visibility,
        "wind_speed": windSpeed,
        "wind_deg": windDeg,
        "wind_gust": windGust,
        "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
        "pop": pop,
      };
}

class Weather {
  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  int id;
  String main;
  String description;
  String icon;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json["id"],
        main: json["main"],
        description: json["description"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "main": main,
        "description": description,
        "icon": icon,
      };
}
