import 'package:flutter/material.dart';
import '../config/color.dart';
import '../view/menu.dart';
import '../api/WeatherFetcher.dart';
import '../api/WeatherOneCallFetcher.dart';
import '../Model/WeatherData.dart';
import '../Model/WeatherOneCallData.dart';
import 'Widget/TextWidget.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<WeatherData> futureWeatherData;
  late Future<WeatherOneCallData> futureWeatherOneCallData;
  var weatherFetcher = WeatherFetcher(city: "Saint-Étienne-de-Montluc");
  var weatherOneCallFetcher = WeatherOneCallFetcher(
      latitude: "47.27", longitude: "-1.79", time: "hourly");

  @override
  void initState() {
    super.initState();
    futureWeatherData = weatherFetcher.fetchData();
    futureWeatherOneCallData = weatherOneCallFetcher.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Home"),
            ),
            backgroundColor: backgroundColor,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: FutureBuilder<WeatherData>(
                future: futureWeatherData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Header(
                            cityName: snapshot.data!.name,
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: WeatherContent(
                            weatherData: snapshot.data!,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: FutureBuilder<WeatherOneCallData>(
                            future: futureWeatherOneCallData,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return WeatherDetailsWrapper(
                                    weatherOneCallData: snapshot.data!);
                              } else if (snapshot.hasError) {
                                return Center(child: Text("${snapshot.error}"));
                              }

                              // By default, show a loading spinner.
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  }

                  // By default, show a loading spinner.
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            bottomNavigationBar: Menu(
              selectedIndex: 0,
            )));
  }
}

class Header extends StatefulWidget {
  String cityName;
  var date = DateTime.now();
  Header({Key? key, this.cityName = "undefined"}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 12,
            ),
            H1Text(innerText: widget.cityName),
            SizedBox(
              height: 15,
            ),
            H5Text(
              innerText: widget.date.toString(),
              fontColor: subTitleText,
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherContent extends StatefulWidget {
  WeatherData weatherData;
  WeatherContent({Key? key, required this.weatherData}) : super(key: key);

  @override
  _WeatherContentState createState() => _WeatherContentState();
}

class _WeatherContentState extends State<WeatherContent> {
  int windSpeedKMH() {
    return (widget.weatherData.wind.speed * 3.6).round();
  }

  @override
  Widget build(BuildContext context) {
    WeatherData weatherData = widget.weatherData;
    String temp = "${weatherData.main.temp.round().toString()}°";
    String wind = "${windSpeedKMH().toString()}km/h";
    String humidity = "${weatherData.main.humidity}%";
    return Container(
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: Image(
              height: MediaQuery.of(context).size.height / 2.5,
              image: AssetImage('assets/weatherIcon/cloud/12.png'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              WeatherInfo(label: "Temp", data: temp),
              WeatherInfo(label: "Wind", data: wind),
              WeatherInfo(label: "Humidity", data: humidity)
            ],
          )
        ],
      ),
    );
  }
}

class WeatherInfo extends StatelessWidget {
  String label;
  String data;
  WeatherInfo({Key? key, this.label = "", this.data = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        H4Text(
          innerText: label,
          fontColor: subTitleText,
        ),
        SizedBox(
          height: 6,
        ),
        H3Text(
          innerText: data,
        )
      ],
    );
  }
}

class WeatherDetailsWrapper extends StatefulWidget {
  WeatherOneCallData weatherOneCallData;
  WeatherDetailsWrapper({Key? key, required this.weatherOneCallData})
      : super(key: key);

  @override
  _WeatherDetailsWrapperState createState() => _WeatherDetailsWrapperState();
}

class _WeatherDetailsWrapperState extends State<WeatherDetailsWrapper> {
  int itemCount(var listHourly) {
    int index = 0;
    var now = DateTime.now();
    var nextMidnight =
        ((DateTime(now.year, now.month, now.day, 1).add(Duration(days: 1))));
    print(nextMidnight);
    listHourly.forEach((hourly) {
      var hourlyTimestamp =
          DateTime.fromMillisecondsSinceEpoch(hourly.dt * 1000);
      if (hourlyTimestamp.isBefore(nextMidnight)) {
        index++;
      }
    });
    return index;
  }

  bool _currentWeather(int timestamp) {
    bool current = false;
    DateTime now = DateTime.now();
    DateTime currentHour = ((DateTime(now.year, now.month, now.day, now.hour)));
    DateTime dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    if (dateFromTimeStamp.isAtSameMomentAs(currentHour)) {
      current = true;
    }
    return current;
  }

  String timeStampToHour(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${date.hour.toString()}:00";
  }

  @override
  Widget build(BuildContext context) {
    Widget _weatherWidget;
    WeatherOneCallData weatherOneCallData = widget.weatherOneCallData;
    return Container(
        child: Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Flex(
            direction: Axis.vertical,
            children: [
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Align(
                  child: H2Text(innerText: "Today"),
                  alignment: Alignment.centerLeft,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: itemCount(weatherOneCallData.hourly),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    String hour =
                        timeStampToHour(weatherOneCallData.hourly[index].dt);
                    String temp = weatherOneCallData.hourly[index].temp
                        .round()
                        .toString();
                    _weatherWidget = WeatherDetailsCard(
                      hour: hour,
                      temp: temp,
                    );
                    print(_currentWeather(weatherOneCallData.hourly[index].dt));

                    if (_currentWeather(weatherOneCallData.hourly[index].dt) ==
                        true) {
                      _weatherWidget = WeatherDetailsCard(
                          hour: hour,
                          temp: temp,
                          backgroundColor: secondaryColor);
                    }
                    return _weatherWidget;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class WeatherDetailsCard extends StatefulWidget {
  String temp;
  String hour;
  Color backgroundColor;
  WeatherDetailsCard(
      {Key? key,
      required this.hour,
      required this.temp,
      this.backgroundColor = thirdColor})
      : super(key: key);

  @override
  _WeatherDetailsCardState createState() => _WeatherDetailsCardState();
}

class _WeatherDetailsCardState extends State<WeatherDetailsCard> {
  @override
  Widget build(BuildContext context) {
    String temp = "${widget.temp}°";
    String hour = "${widget.hour}h";
    return LimitedBox(
        maxHeight: 30,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: widget.backgroundColor),
          width: 140,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            direction: Axis.horizontal,
            children: [
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    child: Image(
                      height: constraints.maxHeight / 1.5,
                      image: AssetImage('assets/weatherIcon/cloud/12.png'),
                    ),
                  );
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [H5Text(innerText: hour), H3Text(innerText: temp)],
              )
            ],
          ),
        ));
  }
}
