import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:journey/bookings.dart";
import "package:journey/helpers/colors.dart";
import "package:journey/profile.dart";

import "home.dart";

class Navigation extends StatefulWidget {

  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => NavigationState();

}

class NavigationState extends State<Navigation> {

  int selectedIndex = 0;
  double iconSize = 25;
  double fontSize = 14;
  String isSignedIn = "no";
  List<Widget> widgetOptions = [
    const Home(),
    const Bookings(),
    const Profile()
  ];

  void onItemTap(int index) {
    selectedIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = (ModalRoute.of(context)?.settings.arguments ??
          <String, dynamic>{}) as Map;
      if (arguments.isNotEmpty) {
        selectedIndex = arguments["screen"];
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                height: 1.5,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                height: 1.5,
              ),
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedIndex,
              selectedItemColor: primaryMedium,
              iconSize: iconSize,
              onTap: onItemTap,
              items: const [
                BottomNavigationBarItem(
                    label: "Home",
                    activeIcon: Icon(FontAwesomeIcons.house),
                    icon: Icon(FontAwesomeIcons.house)),
                BottomNavigationBarItem(
                  label: "Bookings",
                  activeIcon: Icon(FontAwesomeIcons.ticket),
                  icon: Icon(FontAwesomeIcons.ticket),
                ),
                BottomNavigationBarItem(
                  label: "Profile",
                  activeIcon: Icon(FontAwesomeIcons.circleUser),
                  icon: Icon(FontAwesomeIcons.circleUser),
                )
              ]),
        ),
      ),
    );
  }

}
