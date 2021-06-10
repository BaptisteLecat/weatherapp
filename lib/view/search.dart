import 'package:flutter/material.dart';
import 'package:weatherapp/Model/WeatherData.dart';
import '../config/color.dart';
import '../view/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatelessWidget {
  static const routeName = "/search";
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search"),
        ),
        backgroundColor: backgroundColor,
        body: Center(
          child: WeatherDisplayer(),
        ),
        bottomNavigationBar: Menu(
          selectedIndex: 1,
        ));
  }
}

Future<WeatherData> fetchWeatherData() async {
  final response = await http.get(Uri.parse(
      'api.openweathermap.org/data/2.5/weather?q=London&appid=15952e9f2c2b18301f1694c268015c1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(jsonDecode(response.body));
    return WeatherData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load weatherData');
  }
}

class WeatherDisplayer extends StatefulWidget {
  const WeatherDisplayer({Key? key}) : super(key: key);

  @override
  _WeatherDisplayerState createState() => _WeatherDisplayerState();
}

class _WeatherDisplayerState extends State<WeatherDisplayer> {
  late Future<WeatherData> futureWeatherData;

  @override
  void initState() {
    super.initState();
    futureWeatherData = fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder<WeatherData>(
          future: futureWeatherData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.weather[0].description);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
