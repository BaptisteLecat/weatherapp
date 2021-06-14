import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/color.dart';

class H1Text extends StatelessWidget {
  final String innerText;
  final Color fontColor;
  const H1Text(
      {Key? key, required this.innerText, this.fontColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      innerText,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            color: fontColor, fontWeight: FontWeight.bold, fontSize: 24),
      ),
    );
  }
}

class H2Text extends StatelessWidget {
  final String innerText;
  final Color fontColor;
  const H2Text(
      {Key? key, required this.innerText, this.fontColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      innerText,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            color: fontColor, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}

class H3Text extends StatelessWidget {
  final String innerText;
  final Color fontColor;
  const H3Text(
      {Key? key, required this.innerText, this.fontColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      innerText,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            color: fontColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

class H4Text extends StatelessWidget {
  final String innerText;
  final Color fontColor;
  const H4Text(
      {Key? key, required this.innerText, this.fontColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      innerText,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            color: fontColor, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

class H5Text extends StatelessWidget {
  final String innerText;
  final Color fontColor;
  const H5Text(
      {Key? key, required this.innerText, this.fontColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      innerText,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            color: fontColor, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
