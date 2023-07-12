import "helper.dart";

customPush(String route) {
  Navigate.navigatorKey.currentState!.pushNamed(route);
}

customPushWithArgument(String route, Object? arguments) {
  Navigate.navigatorKey.currentState!.pushNamed(route, arguments: arguments);
}

customPushAndRemoveUntil(String route) {
  Navigate.navigatorKey.currentState!
      .pushNamedAndRemoveUntil(route, (route) => false);
}

customPushAndRemoveUntilWithArgument(String route, Object? arguments) {
  Navigate.navigatorKey.currentState!
      .pushNamedAndRemoveUntil(route, (route) => false, arguments: arguments);
}
