import "package:flutter/material.dart";
import "package:journey/bookings.dart";
import "package:journey/navigation.dart";
import "package:journey/payment.dart";
import "package:journey/profile.dart";
import "package:journey/splash.dart";
import "package:journey/start.dart";
import "package:journey/trip-details.dart";
import "package:journey/widgets/confirmed.dart";

class Routes {

  static const splash = "/";
  static const start = "start";
  static const navigation = "navigation";
  static const bookings = "bookings";
  static const tripDetails = "trip-details";
  static const payment = "payment";
  static const designers = "designers";
  static const designerDetail = "designerDetail";
  static const articles = "articles";
  static const collection = "collection";
  static const articleDetail = "articleDetail";
  static const collectionDetail = "collectionDetail";
  static const profile = "profile";
  static const confirmed = "confirmed";
  static const settings = "settings";
  static const unknown = "404";

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {
      splash: (BuildContext context) => const Splash(),
      start: (BuildContext context) => const Start(),
      navigation: (BuildContext context) => const Navigation(),
      bookings: (BuildContext context) => const Bookings(),
      tripDetails: (BuildContext context) => const TripDetails(),
      payment: (BuildContext context) => const Payment(),
      confirmed: (BuildContext context) => Confirmed(),
      profile: (BuildContext context) => const Profile(),
    };
    return routes;
  }

}
