import "package:flutter/material.dart";

class NotificationService {

  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    messengerKey.currentState!.showSnackBar(snackBar);

  }
}

class Navigate {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
