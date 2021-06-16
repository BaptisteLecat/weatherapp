import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/color.dart';
import '../../responsive.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';

class H1Text extends StatelessWidget {
  final String innerText;
  final Color fontColor;
  final BuildContext context;
  const H1Text(
      {Key? key,
      required this.context,
      required this.innerText,
      this.fontColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return AutoSizeText(
      innerText,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            color: fontColor,
            fontWeight: FontWeight.bold,
            fontSize: isMobile(context) ? 24 : 60),
      ),
    );
  }
}

class H2Text extends StatelessWidget {
  final String innerText;
  final Color fontColor;
  final BuildContext context;
  const H2Text(
      {Key? key,
      required this.context,
      required this.innerText,
      this.fontColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      innerText,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            color: fontColor,
            fontWeight: FontWeight.bold,
            fontSize: isMobile(context) ? 20 : 60),
      ),
    );
  }
}

class H3Text extends StatelessWidget {
  final String innerText;
  final Color fontColor;
  final BuildContext context;
  const H3Text(
      {Key? key,
      required this.context,
      required this.innerText,
      this.fontColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      innerText,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            color: fontColor,
            fontWeight: FontWeight.bold,
            fontSize: isMobile(context) ? 18 : 46),
      ),
    );
  }
}

class H4Text extends StatelessWidget {
  final String innerText;
  final Color fontColor;
  final BuildContext context;
  const H4Text(
      {Key? key,
      required this.context,
      required this.innerText,
      this.fontColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      innerText,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            color: fontColor,
            fontWeight: FontWeight.bold,
            fontSize: isMobile(context) ? 16 : 40),
      ),
    );
  }
}

class H5Text extends StatelessWidget {
  final String innerText;
  final Color fontColor;
  final BuildContext context;
  const H5Text(
      {Key? key,
      required this.context,
      required this.innerText,
      this.fontColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      innerText,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            color: fontColor,
            fontWeight: FontWeight.bold,
            fontSize: isMobile(context) ? 14 : 36),
      ),
    );
  }
}
