import "package:firebase_auth/firebase_auth.dart";
import "package:get/get.dart";

import "../helpers/navigators.dart";
import "../helpers/shared-preferences.dart";
import "../routers/router.dart";

class UserController extends GetxController {

  var userId = "null".obs;
  var email = "null".obs;
  var name = "null".obs;

  @override
  void onInit() {
    super.onInit();
    checkUser();
  }

  void checkUser() async {
    userId.value = await getStringValue("userid") ?? "null";
    email.value = await getStringValue("email") ?? "null";
    name.value = await getStringValue("name") ?? "";
  }

  void setUser(String userId, String email, String name) async {
    await setStringValue("userid", userId);
    await setStringValue("email", email);
    await setStringValue("name", name);
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    removeAll();
    checkUser();
    customPushAndRemoveUntil(Routes.start);
  }

}
