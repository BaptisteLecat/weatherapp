import 'package:flutter/material.dart';
import 'view/home/home.dart';
import 'view/forecast.dart';
import 'view/search.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => HomePage());
      case "/home":
        return MaterialPageRoute(builder: (_) => HomePage());
      case "/search":
        return MaterialPageRoute(builder: (_) => SearchPage());
      case "/forecast":
        return MaterialPageRoute(builder: (_) => ForecastPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("ErrorPage"),
        ),
        body: Center(
          child: Text("Error 404"),
        ),
      );
    });
  }
}
