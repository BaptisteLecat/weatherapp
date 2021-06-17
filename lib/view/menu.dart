import 'package:flutter/material.dart';
import '../config/color.dart';
import '../../responsive.dart';

class Menu extends StatefulWidget {
  final int selectedIndex;
  const Menu({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void _redirectTo(index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          '/home',
        );
        break;
      case 1:
        Navigator.pushReplacementNamed(
          context,
          '/search',
        );
        break;
      case 2:
        Navigator.pushReplacementNamed(
          context,
          '/forecast',
        );
        break;
      default:
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _redirectTo(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: isMobile(context) ? 20 : 50,
      selectedFontSize: isMobile(context) ? 14 : 36,
      unselectedFontSize: isMobile(context) ? 12 : 30,
      type: BottomNavigationBarType.fixed,
      fixedColor: selectedIconColor,
      unselectedItemColor: unselectedIconColor,
      elevation: 8,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            activeIcon: Icon(Icons.home_filled)),
        BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: "Search",
            activeIcon: Icon(Icons.search)),
        BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: "Forecast",
            activeIcon: Icon(Icons.analytics_outlined)),
      ],
      backgroundColor: backgroundColor,
      currentIndex: widget.selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
