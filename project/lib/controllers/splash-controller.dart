import "package:get/get.dart";

import "../helpers/navigators.dart";
import "../routers/router.dart";
import "user-controller.dart";

class SplashController extends GetxController {

  SplashServices splashServices = SplashServices();

  @override
  void onInit() {
    super.onInit();
    splashServices.checkAuthentication();
  }

}

class SplashServices {
  void checkAuthentication() async {
    if (Get.find<UserController>().userId.value == "null") {
      await Future.delayed(const Duration(seconds: 3));
      customPushAndRemoveUntil(Routes.start);
    } else {
      await Future.delayed(const Duration(seconds: 3));
      customPushAndRemoveUntil(Routes.navigation);
    }
  }
}
