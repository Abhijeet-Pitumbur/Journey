import "package:carousel_slider/carousel_slider.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:get/instance_manager.dart";
import "package:journey/controllers/user-controller.dart";
import "package:journey/helpers/colors.dart";
import "package:journey/helpers/navigators.dart";
import "package:journey/routers/router.dart";
import "package:journey/widgets/loading.dart";

class Bookings extends StatefulWidget {

  const Bookings({Key? key}) : super(key: key);

  @override
  State<Bookings> createState() => BookingsState();

}

class BookingsState extends State<Bookings> {

  CarouselController carouselController = CarouselController();
  int currentPage = 0;
  List bookings = [];
  CollectionReference collection = FirebaseFirestore.instance.collection("bookings");
  bool isLoading = true;

  getBookings() {
    collection
        .where("userid", isEqualTo: Get.find<UserController>().userId.value)
        .snapshots()
        .listen((event) {
      if (mounted) {
        setState(() {
          bookings = event.docs;
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryMedium,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: primaryMedium,
        title: const Text(
          "Bookings",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: isLoading
          ? const Loading()
          : bookings.isEmpty
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryLight,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      height: MediaQuery.of(context).size.height,
                    ),
                    const Center(
                      child: Text(
                        "No bookings yet",
                        style: TextStyle(
                            color: primaryMedium,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryLight,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      height: MediaQuery.of(context).size.height,
                    ),
                    CarouselSlider.builder(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          initialPage: currentPage,
                          onPageChanged: (value, val) {
                            setState(() {
                              currentPage = value;
                            });
                          },
                          enableInfiniteScroll: false,
                          height: 700,
                        ),
                        itemCount: bookings.length,
                        itemBuilder:
                            (BuildContext context, int i, int pageViewIndex) {
                          return Ticket(
                            ticketNum: bookings[i]["ticketno"],
                            start: bookings[i]["start"],
                            end: bookings[i]["end"],
                            nameStart: bookings[i]["namestart"],
                            nameEnd: bookings[i]["nameend"],
                            price: bookings[i]["amount"],
                            date: bookings[i]["date"],
                            day: bookings[i]["day"],
                            passengers: bookings[i]["passengers"],
                          );
                        }),
                    bookings.length == 1
                        ? const SizedBox()
                        : Positioned(
                            bottom: 55,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      carouselController.previousPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.linear);
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: primaryMedium,
                                      foregroundColor: Colors.white,
                                      child: Icon(FontAwesomeIcons.arrowLeft),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "${currentPage + 1} of  ${bookings.length}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      carouselController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.linear);
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: primaryMedium,
                                      foregroundColor: Colors.white,
                                      child: Icon(FontAwesomeIcons.arrowRight),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(height: 130),
                  ],
                ),
    );
  }

}

class Ticket extends StatelessWidget {

  final String ticketNum;
  final String passengers;
  final String start;
  final String end;
  final String nameStart;
  final String nameEnd;
  final String price;
  final String date;
  final String day;

  const Ticket(
      {Key? key,
      required this.ticketNum,
      required this.start,
      required this.end,
      required this.nameStart,
      required this.nameEnd,
      required this.price,
      required this.date,
      required this.day,
      required this.passengers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        customPushWithArgument(Routes.tripDetails, {
          "start": start,
          "end": end,
          "namestart": nameStart,
          "nameend": nameEnd,
          "passengers": passengers,
          "price": price
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x73000000).withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 1,
                  )
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Ticket #$ticketNum",
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const Spacer(),
                      const CircleAvatar(
                        radius: 19,
                        backgroundColor: primaryMedium,
                        foregroundColor: Colors.white,
                        child: Icon(
                          FontAwesomeIcons.mapLocationDot,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Text(
                        start,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(20)),
                        child: SizedBox(
                          height: 8,
                          width: 8,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade400,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: <Widget>[
                              SizedBox(
                                height: 24,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Flex(
                                      direction: Axis.horizontal,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(
                                        (constraints.constrainWidth() / 6)
                                            .floor(),
                                        (index) => SizedBox(
                                          height: 1,
                                          width: 3,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Center(
                                  child: Icon(
                                FontAwesomeIcons.trainSubway,
                                color: Colors.indigo.shade300,
                                size: 24,
                              ))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            borderRadius: BorderRadius.circular(20)),
                        child: SizedBox(
                          height: 8,
                          width: 8,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.pink.shade400,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        end,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        child: Text(
                          nameStart,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      const Text(
                        "6h 30m",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          nameEnd,
                          textAlign: TextAlign.end,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text(
                        "08:00 AM",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " - ",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "02:30 PM",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Purchased",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        date,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Text(
                        "14:25",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                            (() {
                              if (passengers == "1") {
                                return "1 Passenger in Economy";
                              }
                              return "$passengers Passengers in Economy";
                            }()),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey)),
                        Expanded(
                          child: Text(
                            "\u0024$price",
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    height: 25,
                    width: 15,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(18),
                              bottomRight: Radius.circular(18)),
                          color: primaryLight),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Flex(
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              (constraints.constrainWidth() / 10).floor(),
                              (index) => SizedBox(
                                height: 1,
                                width: 5,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade400),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                    width: 15,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              bottomLeft: Radius.circular(18)),
                          color: primaryLight),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x73000000).withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 1,
                    offset: const Offset(0.0, 10.0),
                  )
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "images/ticket-barcode.png",
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Ticket expires 24 hours\nafter time of purchase",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
