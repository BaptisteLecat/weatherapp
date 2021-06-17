import 'package:flutter/material.dart';

class ThunderStorm {
  static const int id = 2;
  static String defaultIcon = "12";
  static var icons = {
    200: "16",
    201: "16",
    202: "17",
    210: "12",
    211: "12",
    212: "12",
    221: "12",
    230: "24",
    231: "25",
    232: "28"
  };
}

class Drizzle {
  static const int id = 3;
  static String defaultIcon = "5";
  static var icons = {
    300: "13",
    301: "13",
    302: "13",
    310: "13",
    311: "5",
    312: "5",
    313: "5",
    314: "5",
    321: "5",
  };
}

class Rain {
  static const int id = 5;
  static String defaultIcon = "7";
  static var icons = {
    500: "8",
    501: "8",
    502: "8",
    503: "8",
    504: "8",
    511: "22",
    520: "7",
    521: "7",
    522: "7",
    531: "7",
  };
}

class Snow {
  static const int id = 6;
  static String defaultIcon = "18";
  static var icons = Map();
}

class Atmosphere {
  static const int id = 7;
  static String defaultIcon = "4";
  static var icons = Map();
}

class CloudClear {
  static const int id = 8;
  static String defaultIcon = "27";
  static var icons = {
    800: "26",
    801: "27",
    802: "27",
    803: "35",
    804: "35",
  };
}
