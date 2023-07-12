import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:get/get.dart";
import "package:journey/controllers/stripe-controller.dart";
import "package:journey/helpers/colors.dart";
import "package:journey/widgets/buttons.dart";
import "package:journey/widgets/loading.dart";

class Payment extends StatefulWidget {

  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => PaymentState();

}

class PaymentState extends State<Payment> {

  bool isLoading = false;
  int val = -1;
  String start = "";
  String end = "";
  String nameStart = "";
  String nameEnd = "";
  String passengers = "";
  String price = "";
  List payment = [
    {"name": "Visa", "image": "images/payment-visa.png"},
    {"name": "MasterCard", "image": "images/payment-mastercard.png"},
    {"name": "PayPal", "image": "images/payment-paypal.png"},
    {"name": "American Express", "image": "images/payment-amex.png"},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = (ModalRoute.of(context)?.settings.arguments ??
          <String, dynamic>{}) as Map;
      if (arguments.isNotEmpty) {
        start = arguments["start"];
        end = arguments["end"];
        passengers = arguments["passengers"];
        nameStart = arguments["namestart"];
        nameEnd = arguments["nameend"];
        price = arguments["price"];
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StripeController());
    return Scaffold(
      extendBody: true,
      backgroundColor: primaryMedium,
      appBar: AppBar(
        leading: CustomIconButton(
          color: Colors.white,
          icon: FontAwesomeIcons.arrowLeft,
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 90,
        backgroundColor: primaryMedium,
        title: const Text(
          "Payment",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      bottomNavigationBar: isLoading
          ? const Loading()
          : Container(
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(35),
                    topLeft: Radius.circular(35)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: MaterialButton(
                textColor: Colors.white,
                minWidth: 240,
                height: 60,
                onPressed: () {
                  if (val != -1) {
                    setState(() => isLoading = true);
                    controller.makePayment(
                        amount: price,
                        currency: "USD",
                        start: start,
                        end: end,
                        nameStart: nameStart,
                        nameEnd: nameEnd,
                        passengers: passengers);
                    setState(() => isLoading = false);
                  }
                },
                color: primaryMedium,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: const Text(
                  "Proceed to Payment",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
      body: isLoading
          ? const SizedBox()
          : Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: primaryLight,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            "Choose a payment method",
                            style: TextStyle(
                                color: primaryMedium,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: payment.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: primaryLight,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: RadioListTile(
                                activeColor: primaryDark,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                value: i,
                                groupValue: val,
                                onChanged: (int? value) => setState(() {
                                  val = value!;
                                }),
                                title: Row(
                                  children: [
                                    Image.asset(
                                      payment[i]["image"],
                                      width: 55,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      payment[i]["name"],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: primaryDark),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

}
