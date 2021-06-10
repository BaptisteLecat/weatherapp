import 'package:flutter/material.dart';
import '../config/color.dart';
import '../view/menu.dart';

class HomePage extends StatelessWidget {
  static const routeName = "/home";
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        backgroundColor: backgroundColor,
        body: Center(
          child: Text("Home"),
        ),
        bottomNavigationBar: Menu(
          selectedIndex: 0,
        ));
  }
}
