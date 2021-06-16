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
  static String defaultIcon = "23";
  static var icons = {
    300: "23",
    301: "23",
    302: "23",
    310: "22",
    311: "22",
    312: "22",
    313: "22",
    314: "22",
    321: "22",
  };
}

class Rain {
  static const int id = 4;
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
