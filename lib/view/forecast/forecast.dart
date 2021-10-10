import 'package:flutter/material.dart';
import 'package:weatherapp/Model/WeatherIcon/WeatherIcon.dart';
import '../../config/color.dart';
import '../menu.dart';
import '../../api/WeatherFetcher.dart';
import '../../api/WeatherOneCallFetcher.dart';
import '../../Model/WeatherData.dart';
import '../../Model/WeatherOneCallHourlyData.dart';
import '../../Model/WeatherOneCallDailyData.dart';
import '../Widget/TextWidget.dart';
import '../../responsive.dart';
import '../../geolocation/UserLocation.dart';
import 'package:location/location.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({Key? key}) : super(key: key);

  @override
  _ForecastPage createState() => _ForecastPage();
}

class _ForecastPage extends State<ForecastPage> {
  late Future<WeatherOneCallHourlyData> futureWeatherTodayData;

  late Future<WeatherOneCallDailyData> futureWeatherForecastData;

  late Future<LocationData> futurePosition;
  var position;

  @override
  void initState() {
    super.initState();
    initPosition();
  }

  void initPosition() {
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
      {String latitude = "48.85639", String longitude = "2.35204"}) {
    setState(() {
      var weatherForecastFetcher =
          WeatherOneCallFetcher(latitude: latitude, longitude: longitude);
      var weatherTodayFetcher = WeatherOneCallFetcher(
          latitude: latitude, longitude: longitude, time: "hourly");
      futureWeatherForecastData = weatherForecastFetcher.fetchDailyData();
      futureWeatherTodayData = weatherTodayFetcher.fetchHourlyData();
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
              child: OrientationBuilder(
                  builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.portrait) {
                  return PortraitDisplay(
                      futureWeatherTodayData: futureWeatherTodayData,
                      futureWeatherForecastData: futureWeatherForecastData);
                } else {
                  return LandscapeDisplay(
                      futureWeatherTodayData: futureWeatherTodayData,
                      futureWeatherForecastData: futureWeatherForecastData);
                }
              }),
            ),
            bottomNavigationBar: Menu(
              selectedIndex: 0,
            )));
  }
}

class PortraitDisplay extends StatefulWidget {
  late Future<WeatherOneCallHourlyData> futureWeatherTodayData;
  late Future<WeatherOneCallDailyData> futureWeatherForecastData;
  PortraitDisplay(
      {Key? key,
      required this.futureWeatherTodayData,
      required this.futureWeatherForecastData})
      : super(key: key);

  @override
  _PortraitDisplayState createState() => _PortraitDisplayState();
}

class _PortraitDisplayState extends State<PortraitDisplay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 1, child: Header()),
        Expanded(
          flex: 2,
          child: FutureBuilder<WeatherOneCallHourlyData>(
            future: widget.futureWeatherTodayData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 25, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          H2Text(context: context, innerText: "Today"),
                          H4Text(context: context, innerText: "28 May, 2021")
                        ],
                      ),
                    ),
                    WeatherDetailsWrapper(weatherTodayData: snapshot.data!)
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
        Expanded(
          flex: 6,
          child: ForecastDisplay(
              futureWeatherForecastData: widget.futureWeatherForecastData),
        )
      ],
    );
  }
}

class LandscapeDisplay extends StatefulWidget {
  late Future<WeatherOneCallHourlyData> futureWeatherTodayData;
  late Future<WeatherOneCallDailyData> futureWeatherForecastData;
  LandscapeDisplay(
      {Key? key,
      required this.futureWeatherTodayData,
      required this.futureWeatherForecastData})
      : super(key: key);
  @override
  _LandscapeDisplayState createState() => _LandscapeDisplayState();
}

class _LandscapeDisplayState extends State<LandscapeDisplay> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: FutureBuilder<WeatherOneCallHourlyData>(
              future: widget.futureWeatherTodayData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait) {
                    return Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 25, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H2Text(context: context, innerText: "Today"),
                              H4Text(
                                  context: context, innerText: "28 May, 2021")
                            ],
                          ),
                        ),
                        WeatherDetailsWrapper(weatherTodayData: snapshot.data!)
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 25, left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              H2Text(context: context, innerText: "Today"),
                              H4Text(
                                  context: context, innerText: "28 May, 2021")
                            ],
                          ),
                        ),
                        Expanded(
                          child: WeatherDetailsWrapper(
                              weatherTodayData: snapshot.data!),
                        )
                      ],
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                }

                // By default, show a loading spinner.
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            flex: 4,
            child: ForecastDisplay(
                futureWeatherForecastData: widget.futureWeatherForecastData),
          )
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: H1Text(context: context, innerText: "Forecast report"),
      ),
    );
  }
}

class WeatherDetailsWrapper extends StatefulWidget {
  WeatherOneCallHourlyData weatherTodayData;
  WeatherDetailsWrapper({Key? key, required this.weatherTodayData})
      : super(key: key);

  @override
  _WeatherDetailsWrapperState createState() => _WeatherDetailsWrapperState();
}

class _WeatherDetailsWrapperState extends State<WeatherDetailsWrapper> {
  List<Widget> constructList(var listHourly) {
    List<WeatherDetailsCard> listCard = [];
    for (var index = 0; index < itemCount(listHourly); index++) {
      String hour = timeStampToHour(widget.weatherTodayData.hourly[index].dt);
      String temp =
          widget.weatherTodayData.hourly[index].temp.round().toString();
      int idWeather = widget.weatherTodayData.hourly[index].weather[0].id;

      if (_currentWeather(widget.weatherTodayData.hourly[index].dt) == true) {
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
    WeatherOneCallHourlyData weatherOneCallData = widget.weatherTodayData;
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
        return Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: constructList(weatherOneCallData.hourly),
            ),
          ),
        );
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
          height: (constraints.maxWidth > 200) ? 150 : 80,
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

class ForecastDisplay extends StatefulWidget {
  Future<WeatherOneCallDailyData> futureWeatherForecastData;
  ForecastDisplay({Key? key, required this.futureWeatherForecastData})
      : super(key: key);

  @override
  _ForecastDisplayState createState() => _ForecastDisplayState();
}

class _ForecastDisplayState extends State<ForecastDisplay> {
  List<Widget> _constructList(var listDaily) {
    List<ForecastDetailsCard> listCard = [];
    _itemList(listDaily).forEach((daily) {
      String day = _getFormatedDay(daily.dt);
      String dateMonth = _getFormatedDateMonth(daily.dt);
      String temp = daily.temp.day.round().toString();
      int idWeather = daily.weather[0].id;
      listCard.add(ForecastDetailsCard(
        temperature: temp,
        day: day,
        dateMonth: dateMonth,
        idWeather: idWeather,
      ));
    });
    return listCard;
  }

  List<Daily> _itemList(List<Daily> listDaily) {
    List<Daily> listDisplayedDaily = [];
    var now = DateTime.now();
    var nextWeek =
        ((DateTime(now.year, now.month, now.day).add(Duration(days: 8))));
    listDaily.forEach((hourly) {
      var hourlyTimestamp =
          DateTime.fromMillisecondsSinceEpoch(hourly.dt * 1000);
      if (hourlyTimestamp.isBefore(nextWeek) &&
          hourlyTimestamp.day != now.day) {
        listDisplayedDaily.add(hourly);
      }
    });
    return listDisplayedDaily;
  }

  String _getFormatedDay(int timestamp) {
    List<String> weekDays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${weekDays[date.weekday - 1]}";
  }

  String _getFormatedDateMonth(int timestamp) {
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
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${date.day}, ${months[date.month - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.4),
      child: FutureBuilder<WeatherOneCallDailyData>(
        future: widget.futureWeatherForecastData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        H2Text(context: context, innerText: "Next forecast"),
                      ]),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: _constructList(snapshot.data!.daily),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ForecastDetailsCard extends StatefulWidget {
  String day;
  String dateMonth;
  String temperature;
  int idWeather;
  ForecastDetailsCard(
      {Key? key,
      required this.day,
      required this.dateMonth,
      required this.temperature,
      required this.idWeather})
      : super(key: key);

  @override
  _ForecastDetailsCardState createState() => _ForecastDetailsCardState();
}

class _ForecastDetailsCardState extends State<ForecastDetailsCard> {
  @override
  Widget build(BuildContext context) {
    WeatherIcon weatherIcon = WeatherIcon(id: widget.idWeather);
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10),
      height: (isMobile(context)) ? 80 : 130,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: thirdColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H3Text(context: context, innerText: widget.day),
              H4Text(context: context, innerText: widget.dateMonth)
            ],
          ),
          H1Text(context: context, innerText: "${widget.temperature}°"),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                child: Image(
                  height: constraints.maxHeight / 1.2,
                  image: AssetImage(weatherIcon.getWeatherIcon()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
