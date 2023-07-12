import "dart:convert";
import "dart:math";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_stripe/flutter_stripe.dart";
import "package:get/get.dart";
import "package:http/http.dart" as http;
import "package:intl/intl.dart";
import "package:journey/controllers/user-controller.dart";
import "package:journey/helpers/constants.dart";
import "package:journey/helpers/helper.dart";
import "package:journey/helpers/navigators.dart";
import "package:journey/routers/router.dart";

class StripeController extends GetxController {

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(
      {required String amount,
      required String currency,
      required String start,
      required String end,
      required String nameStart,
      required String nameEnd,
      required String passengers}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: true,
          googlePay: true,
          testEnv: true,
          merchantCountryCode: "US",
          merchantDisplayName: "Prospects",
          customerId: paymentIntentData!["customer"],
          paymentIntentClientSecret: paymentIntentData!["client_secret"],
        ));
        displayPaymentSheet(amount, start, end, nameStart, nameEnd, passengers);
      }
    } catch (error) {
      debugPrint("Error: $error");
    }
  }

  String getTicketNum() {
    var random = Random.secure();
    const chars = "1234567890987654321";
    return List.generate(6, (index) => chars[random.nextInt(chars.length)])
        .join()
        .toString();
  }

  displayPaymentSheet(String amount, String start, String end, String nameStart,
      String nameEnd, String passengers) async {
    try {
      String ticketNum = getTicketNum();
      await Stripe.instance.presentPaymentSheet();
      await FirebaseFirestore.instance.collection("bookings").add({
        "passengers": passengers,
        "ticketno": ticketNum,
        "start": start,
        "end": end,
        "namestart": nameStart,
        "nameend": nameEnd,
        "amount": amount,
        "userid": Get.find<UserController>().userId.value,
        "date": DateFormat.yMMMMd().format(DateTime.now()).toString(),
        "day": DateFormat("EEEE").format(DateTime.now()).toString()
      });
      NotificationService.showSnackBar("Payment successful");
      customPushAndRemoveUntil(Routes.confirmed);
    } on Exception catch (error) {
      if (error is StripeException) {
        debugPrint("Stripe Error: ${error.error.localizedMessage}");
      } else {
        debugPrint("Error: $error");
      }
    } catch (error) {
      debugPrint("Error: $error");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        "amount": calculateAmount(amount),
        "currency": currency,
        "payment_method_types[]": "card"
      };
      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization": "Bearer $secretKey",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      return jsonDecode(response.body);
    } catch (error) {
      debugPrint("Error: $error");
    }
  }

  calculateAmount(String amount) {
    final formattedAmount = (int.parse(amount)) * 100;
    return formattedAmount.toString();
  }

}
