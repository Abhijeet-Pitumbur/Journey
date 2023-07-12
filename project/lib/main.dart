import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_stripe/flutter_stripe.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:journey/helpers/colors.dart";
import "package:journey/routers/router.dart";

import "controllers/user-controller.dart";
import "helpers/constants.dart";
import "helpers/helper.dart";

void main() async {
  Stripe.publishableKey = publishableKey;
  Get.put(UserController(), permanent: true);
  await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(const Journey());
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class Journey extends StatelessWidget {

  const Journey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.splash,
      builder: (context, Widget? child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
      scaffoldMessengerKey: NotificationService.messengerKey,
      navigatorKey: Navigate.navigatorKey,
      routes: Routes.getRoutes(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black),
        backgroundColor: Colors.grey.shade400,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryMedium,
        ),
      ),
    );
  }

}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
