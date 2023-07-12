import "package:shared_preferences/shared_preferences.dart";

Future<bool> setSwitchState(String key, bool value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool(key, value);
  return preferences.setBool(key, value);
}

Future<bool?> getSwitchState(String key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool? isSwitched = preferences.getBool(key);
  return isSwitched;
}

setStringValue(String key, String value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString(key, value);
}

Future<String?> getStringValue(String key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(key);
}

Future<bool> containsKey(String key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.containsKey(key);
}

removeValue(String key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.remove(key);
}

removeAll() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.clear();
}
