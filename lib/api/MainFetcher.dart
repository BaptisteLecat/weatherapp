class MainFetcher {
  String apiKey = "415952e9f2c2b18301f1694c268015c1";
  String apiUrl = "http://api.openweathermap.org/data/2.5/";
  String service;
  List<String> geoData = [];
  String apiUnit = "metric";

  MainFetcher(
      {String latitude = "", String longitude = "", required this.service}) {
    if (latitude != "" && longitude != "") {
      this.geoData = [latitude, longitude];
    }
  }

  String urlBuilder() {
    String url = this.apiUrl + this.service + "?";
    if (this.apiKey != "") {
      url += "appid=$apiKey";
    }

    if (this.apiUnit != "") {
      url += "&units=$apiUnit";
    }

    if (this.geoData.isNotEmpty) {
      url += "&lat=${geoData[0]}";
      url += "&lon=${geoData[1]}";
    }

    return url;
  }
}
