import 'package:http/http.dart' as http;
import 'package:weatherapp/api/MainFetcher.dart';
import 'dart:convert';
import '../Model/WeatherOneCallData.dart';

class WeatherOneCallFetcher extends MainFetcher {
  String excludeArgs = "hourly,current,minutely,alerts"; //Default is Daily

  WeatherOneCallFetcher(
      {String latitude = "", String longitude = "", String time = "daily"})
      : super(latitude: latitude, longitude: longitude, service: "onecall") {
    if (latitude != "" && longitude != "") {
      this.geoData = [latitude, longitude];
    }

    if (time == "hourly") {
      this.excludeArgs = "daily,current,minutely,alerts";
    }
  }

  @override
  String urlBuilder() {
    String url = super.urlBuilder();
    url += "&exclude=${this.excludeArgs}";
    print(url);
    return url;
  }

  Future<WeatherOneCallData> fetchData() async {
    final response = await http.get(Uri.parse(urlBuilder()));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(jsonDecode(response.body));
      return WeatherOneCallData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load weatherOneCallData');
    }
  }
}
