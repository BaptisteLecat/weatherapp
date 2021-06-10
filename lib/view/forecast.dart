import 'package:flutter/material.dart';
import '../config/color.dart';
import '../view/menu.dart';

class ForecastPage extends StatelessWidget {
  static const routeName = "/forecast";
  const ForecastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Forecast"),
        ),
        backgroundColor: backgroundColor,
        body: Center(
          child: Text("Forecast"),
        ),
        bottomNavigationBar: Menu(
          selectedIndex: 0,
        ));
  }
}
