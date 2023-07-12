import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";
import "package:journey/helpers/colors.dart";

import "controllers/splash-controller.dart";

class Splash extends StatelessWidget {
  
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            SvgPicture.asset(
              "images/logo-dark.svg",
              color: primaryDark,
              width: 200,
            ),
            const SizedBox(height: 15),
            const Text(
              "METRO BOOKING",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: primaryMedium),
            ),
            const Spacer(),
            Center(
              child: Image.asset(
                "images/splash.png",
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
