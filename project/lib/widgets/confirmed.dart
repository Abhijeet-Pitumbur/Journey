import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:journey/helpers/colors.dart";
import "package:journey/helpers/navigators.dart";
import "package:journey/routers/router.dart";
import "package:journey/widgets/buttons.dart";

// ignore: must_be_immutable
class Confirmed extends StatelessWidget {

  Confirmed({Key? key}) : super(key: key);
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        actions: [
          CustomIconButton(
              icon: FontAwesomeIcons.xmark,
              onPressed: () {
                customPushAndRemoveUntilWithArgument(
                    Routes.navigation, {"screen": 1});
              })
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                  radius: 50,
                  backgroundColor: primaryMedium,
                  child: Icon(
                    FontAwesomeIcons.check,
                    size: 45,
                    color: Colors.white,
                  )),
              SizedBox(height: screenHeight * 0.1),
              const Text(
                "Thank you!",
                style: TextStyle(
                  color: primaryMedium,
                  fontWeight: FontWeight.w600,
                  fontSize: 36,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              const Text(
                "Booking confirmed",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              const Text(
                "You can now scan your ticket at the\ncounter of the metro station",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: screenHeight * 0.06),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: MaterialButton(
                  textColor: Colors.white,
                  minWidth: MediaQuery.of(context).size.width,
                  height: 60,
                  onPressed: () {
                    customPushAndRemoveUntilWithArgument(
                        Routes.navigation, {"screen": 1});
                  },
                  color: primaryMedium,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    "View Bookings",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class ContentRow extends StatelessWidget {

  final String heading;
  final String description;
  final double? fontSize;

  const ContentRow(
      {Key? key,
      required this.heading,
      required this.description,
      this.fontSize = 14})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(heading,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600)),
          Text(description,
              style:
                  TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

}
