import 'package:flutter/material.dart';
import 'package:weatherapp/Model/WeatherIcon/WeatherIcon.dart';
import '../../config/color.dart';
import '../menu.dart';
import '../../api/WeatherFetcher.dart';
import '../../api/WeatherOneCallFetcher.dart';
import '../../Model/WeatherData.dart';
import '../../Model/WeatherOneCallHourlyData.dart';
import '../Widget/TextWidget.dart';
import '../../responsive.dart';
import '../../geolocation/UserLocation.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<WeatherData> futureWeatherData;

  late Future<WeatherOneCallHourlyData> futureWeatherOneCallData;
  late Future<LocationData> futurePosition;
  var position;

  @override
  void initState() {
    super.initState();
    initPosition();
  }

  void initPosition() {
    loadWeatherData();
    var locationFetcher = UserLocation();
    futurePosition = locationFetcher.determinePosition();
    futurePosition
        .then((positionData) => setState(() {
              position = positionData;
              loadWeatherData(
                  latitude: positionData.latitude.toString(),
                  longitude: positionData.longitude.toString());
            }))
        .catchError((error) => () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error.message)));
              loadWeatherData();
            });
  }

  void loadWeatherData(
      {String latitude = "47.27", String longitude = "-1.79"}) {
    setState(() {
      var weatherFetcher =
          WeatherFetcher(latitude: latitude, longitude: longitude);
      var weatherOneCallFetcher = WeatherOneCallFetcher(
          latitude: latitude, longitude: longitude, time: "hourly");
      futureWeatherOneCallData = weatherOneCallFetcher.fetchHourlyData();
      futureWeatherData = weatherFetcher.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: H4Text(
                innerText: "Home",
                context: context,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_outlined),
                  tooltip: 'Refresh',
                  onPressed: () {
                    initPosition();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Weather data have been refreshed.",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        backgroundColor: secondaryColor,
                      ),
                    );
                  },
                )
              ],
            ),
            backgroundColor: backgroundColor,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: FutureBuilder<WeatherData>(
                future: futureWeatherData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return OrientationBuilder(builder:
                        (BuildContext context, Orientation orientation) {
                      if (orientation == Orientation.portrait) {
                        return PortraitDisplay(
                            snapshot: snapshot,
                            futureWeatherOneCallData: futureWeatherOneCallData);
                      } else {
                        return LandscapeDisplay(
                            snapshot: snapshot,
                            futureWeatherOneCallData: futureWeatherOneCallData);
                      }
                    });
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

class LandscapeDisplay extends StatefulWidget {
  AsyncSnapshot<WeatherData> snapshot;
  late Future<WeatherOneCallHourlyData> futureWeatherOneCallData;
  LandscapeDisplay(
      {Key? key,
      required this.snapshot,
      required this.futureWeatherOneCallData})
      : super(key: key);

  @override
  _LandscapeDisplayState createState() => _LandscapeDisplayState();
}

class _LandscapeDisplayState extends State<LandscapeDisplay> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
            flex: 3,
            child: Container(
              child: Column(
                children: [
                  Header(
                    cityName: widget.snapshot.data!.name,
                  ),
                  Expanded(
                    child: WeatherContent(
                      weatherData: widget.snapshot.data!,
                    ),
                  ),
                ],
              ),
            )),
        Expanded(
          flex: 2,
          child: Container(
            child: FutureBuilder<WeatherOneCallHourlyData>(
              future: widget.futureWeatherOneCallData,
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
          ),
        )
      ],
    );
  }
}

class PortraitDisplay extends StatefulWidget {
  AsyncSnapshot<WeatherData> snapshot;
  late Future<WeatherOneCallHourlyData> futureWeatherOneCallData;
  PortraitDisplay(
      {Key? key,
      required this.snapshot,
      required this.futureWeatherOneCallData})
      : super(key: key);

  @override
  _PortraitDisplayState createState() => _PortraitDisplayState();
}

class _PortraitDisplayState extends State<PortraitDisplay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Header(
            cityName: widget.snapshot.data!.name,
          ),
        ),
        Expanded(
          flex: 3,
          child: WeatherContent(
            weatherData: widget.snapshot.data!,
          ),
        ),
        Expanded(
          flex: 1,
          child: FutureBuilder<WeatherOneCallHourlyData>(
            future: widget.futureWeatherOneCallData,
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
  }
}

class Header extends StatefulWidget {
  String cityName;
  DateTime date = DateTime.now();
  Header({Key? key, this.cityName = "undefined"}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String _getFormatedDate() {
    List<String> weekDays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return "${weekDays[widget.date.weekday]} ${widget.date.day} ${months[widget.date.month]} ${widget.date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            H1Text(
              innerText: widget.cityName,
              context: context,
            ),
            H5Text(
              innerText: _getFormatedDate(),
              fontColor: subTitleText,
              context: context,
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
    int idWeather = weatherData.weather[0].id;
    WeatherIcon weatherIcon = WeatherIcon(id: idWeather);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 2,
            child: Image(
              image: AssetImage(weatherIcon.getWeatherIcon()),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                WeatherInfo(label: "Temp", data: temp),
                WeatherInfo(label: "Wind", data: wind),
                WeatherInfo(label: "Humidity", data: humidity)
              ],
            ),
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
          context: context,
        ),
        SizedBox(
          height: 6,
        ),
        H3Text(
          innerText: data,
          context: context,
        )
      ],
    );
  }
}

class WeatherDetailsWrapper extends StatefulWidget {
  WeatherOneCallHourlyData weatherOneCallData;
  WeatherDetailsWrapper({Key? key, required this.weatherOneCallData})
      : super(key: key);

  @override
  _WeatherDetailsWrapperState createState() => _WeatherDetailsWrapperState();
}

class _WeatherDetailsWrapperState extends State<WeatherDetailsWrapper> {
  List<Widget> constructList(var listHourly) {
    List<WeatherDetailsCard> listCard = [];
    for (var index = 0; index < itemCount(listHourly); index++) {
      String hour = timeStampToHour(widget.weatherOneCallData.hourly[index].dt);
      String temp =
          widget.weatherOneCallData.hourly[index].temp.round().toString();
      int idWeather = widget.weatherOneCallData.hourly[index].weather[0].id;

      if (_currentWeather(widget.weatherOneCallData.hourly[index].dt) == true) {
        listCard.add(WeatherDetailsCard(
            hour: hour,
            temp: temp,
            idWeather: idWeather,
            backgroundColor: secondaryColor));
      } else {
        listCard.add(
            WeatherDetailsCard(hour: hour, temp: temp, idWeather: idWeather));
      }
    }
    return listCard;
  }

  int itemCount(var listHourly) {
    int index = 0;
    var now = DateTime.now();
    var nextMidnight = ((DateTime(now.year, now.month, now.day, now.hour + 1)
        .add(Duration(days: 1))));
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
    WeatherOneCallHourlyData weatherOneCallData = widget.weatherOneCallData;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var orientation = MediaQuery.of(context).orientation;
      if (orientation == Orientation.portrait) {
        return Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: constructList(weatherOneCallData.hourly),
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
        );
      } else {
        return Padding(
            padding:
                EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.2),
            child: SingleChildScrollView(
              child: Column(
                children: constructList(weatherOneCallData.hourly),
              ),
            ));
      }
    });
  }
}

class WeatherDetailsCard extends StatefulWidget {
  String temp;
  String hour;
  int idWeather;
  Color backgroundColor;
  WeatherDetailsCard(
      {Key? key,
      required this.hour,
      required this.temp,
      required this.idWeather,
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
    WeatherIcon weatherIcon = WeatherIcon(id: widget.idWeather);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: widget.backgroundColor),
          height: (constraints.maxWidth > 200) ? 150 : 110,
          margin: (MediaQuery.of(context).orientation == Orientation.landscape)
              ? EdgeInsets.symmetric(vertical: 10)
              : EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      child: Image(
                        height: constraints.maxHeight / 1.5,
                        image: AssetImage(weatherIcon.getWeatherIcon()),
                      ),
                    );
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    H5Text(
                      innerText: hour,
                      context: context,
                    ),
                    H3Text(
                      innerText: temp,
                      context: context,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
