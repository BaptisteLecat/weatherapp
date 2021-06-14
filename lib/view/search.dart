import 'package:flutter/material.dart';
import 'package:weatherapp/Model/WeatherData.dart';
import '../config/color.dart';
import '../view/menu.dart';
import '../api/WeatherFetcher.dart';

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

class WeatherDisplayer extends StatefulWidget {
  const WeatherDisplayer({Key? key}) : super(key: key);

  @override
  _WeatherDisplayerState createState() => _WeatherDisplayerState();
}

class _WeatherDisplayerState extends State<WeatherDisplayer> {
  late Future<WeatherData> futureWeatherData;
  var weatherFetcher = WeatherFetcher(
      city: "Saint-Étienne-de-Montluc", latitude: "47.27", longitude: "-1.78");

  @override
  void initState() {
    super.initState();
    futureWeatherData = weatherFetcher.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
        children: [
          FutureBuilder<WeatherData>(
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
          Text(weatherFetcher.urlBuilder())
        ],
      )),
    );
  }
}
