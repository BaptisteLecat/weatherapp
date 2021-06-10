import 'package:flutter/material.dart';
import 'view/home.dart';
import 'view/menu.dart';
import 'view/search.dart';
import 'config/color.dart';
import 'routerGenerator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouterGenerator.generateRoute,
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
