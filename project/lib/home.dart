import "dart:math";

import "package:dotted_line/dotted_line.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:journey/helpers/colors.dart";
import "package:journey/helpers/helper.dart";
import "package:journey/routers/router.dart";
import "package:journey/widgets/buttons.dart";
import "package:searchable_listview/searchable_listview.dart";

import "helpers/navigators.dart";

class Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();

}

class HomeState extends State<Home> {

  String start = "Choose...";
  String end = "Choose...";
  String nameStart = "Choose...";
  String nameEnd = "Choose...";
  String price = "60";
  List passengers = [1, 0];
  List stations = [
    {"name": "Victoria", "symbol": "VTR"},
    {"name": "St Louis", "symbol": "SLO"},
    {"name": "Coromandel", "symbol": "CRM"},
    {"name": "Barkly", "symbol": "BRK"},
    {"name": "Vandermeersch", "symbol": "VDM"},
    {"name": "Rose-Hill", "symbol": "RHL"},
    {"name": "Belle Rose", "symbol": "BLR"},
    {"name": "Quatre Bornes", "symbol": "QBN"},
    {"name": "St Jean", "symbol": "SJN"},
    {"name": "Trianon", "symbol": "TRN"},
    {"name": "Phoenix", "symbol": "PHN"},
    {"name": "Réduit", "symbol": "RDT"},
    {"name": "Curepipe", "symbol": "CPE"},
  ];

  setStartEnd(String value, String name, String type) {
    if (type == "start") {
      setState(() {
        start = value;
        nameStart = name;
      });
    } else if (type == "end") {
      setState(() {
        end = value;
        nameEnd = name;
      });
    }
  }

  showPopup({required String type, required BuildContext context}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Scaffold(
            extendBody: true,
            backgroundColor: primaryMedium,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: MaterialButton(
                textColor: Colors.white,
                minWidth: 300,
                height: 60,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                color: primaryMedium,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: const Text(
                  "Done",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            appBar: AppBar(
              leading: CustomIconButton(
                color: Colors.white,
                icon: FontAwesomeIcons.arrowLeft,
                onPressed: () => Navigator.of(context).pop(),
              ),
              toolbarHeight: 90,
              backgroundColor: primaryMedium,
              title: const Text(
                "Choose Station",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            body: Stack(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 19, vertical: 32),
                    child: SearchableList(
                      initialList: stations,
                      builder: (dynamic list) => Container(
                        decoration: BoxDecoration(
                            color: primaryLight,
                            borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTileTheme(
                          selectedTileColor: primaryMedium,
                          selectedColor: primaryLight,
                          child: ListTile(
                            onTap: () {
                              setStartEnd(list["symbol"], list["name"], type);
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            title: Text(
                              list["name"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryDark),
                            ),
                            subtitle: Text(list["symbol"]),
                          ),
                        ),
                      ),
                      filter: (value) => stations
                          .where(
                            (element) =>
                                element["name"].toLowerCase().contains(value),
                          )
                          .toList(),
                      emptyWidget: const Text("No matches"),
                      inputDecoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        hintText: "Search...",
                        hoverColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2),
                        ),
                        disabledBorder: InputBorder.none,
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  showPopupPassengers({required BuildContext context}) async {
    final result = await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return PassengersCount(list: passengers);
        });
      },
    );
    passengers = result as List;
    total(price, passengers[0] + passengers[1]);
    setState(() {});
  }

  Widget summary({required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: primaryDark, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            description,
            style: const TextStyle(
                color: primaryDark, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  String getTicketNum() {
    var random = Random.secure();
    const chars = "1234567890987654321";
    return List.generate(2, (index) => chars[random.nextInt(chars.length)])
        .join()
        .toString();
  }

  int grandTotal = 0;

  total(String price, int passengers) {
    int totalPassenger = passengers * 5;
    int total = int.parse(price) + totalPassenger;
    grandTotal = total;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget dottedLine({double height = 80}) {
    return DottedLine(
      direction: Axis.vertical,
      lineLength: height,
      dashColor: Colors.grey,
    );
  }

  Widget gpsCircle() {
    return const CircleAvatar(
      radius: 11,
      backgroundColor: primaryMedium,
      child: CircleAvatar(
        radius: 6,
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipPath(
          clipper: CustomShape(),
          child: Container(
            color: primaryMedium,
            child: Center(
              child: SvgPicture.asset(
                "images/logo-dark.svg",
                color: Colors.white,
                width: 190,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 550,
              decoration: BoxDecoration(
                color: primaryMedium.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                color: primaryMedium.withOpacity(0.13),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 50),
            child: Column(
              children: [
                const Text(
                  "Where are you going today?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryMedium),
                ),
                const SizedBox(height: 14),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x73000000).withOpacity(0.2),
                          blurRadius: 10.0,
                          spreadRadius: 1,
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                gpsCircle(),
                                dottedLine(),
                                gpsCircle(),
                              ],
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showPopup(
                                          type: "start", context: context);
                                      if (start != "" && end != "") {
                                        setState(() {
                                          price = getTicketNum();
                                          total(price,
                                              passengers[0] + passengers[1]);
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "From",
                                              style: TextStyle(
                                                color: primaryMedium,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              start == ""
                                                  ? "Choose..."
                                                  : nameStart,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: primaryDark),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    width: 210,
                                    color: Colors.grey.shade300,
                                    height: 3,
                                  ),
                                  const SizedBox(height: 15),
                                  GestureDetector(
                                    onTap: () {
                                      showPopup(type: "end", context: context);
                                      setState(() {
                                        price = getTicketNum();
                                        total(price,
                                            passengers[0] + passengers[1]);
                                      });
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "To",
                                              style: TextStyle(
                                                color: primaryMedium,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              end == "" ? "Choose..." : nameEnd,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: primaryDark),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x73000000).withOpacity(0.2),
                          blurRadius: 10.0,
                          spreadRadius: 1,
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showPopupPassengers(context: context);
                          },
                          child: Column(
                            children: [
                              const Text(
                                "Passengers and Class",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: primaryMedium,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                (() {
                                  if (passengers[0] + passengers[1] == 1) {
                                    return "1 Passenger in Economy";
                                  }
                                  return "${passengers[0] + passengers[1]} Passengers in Economy";
                                }()),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryDark),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    summary(title: "Total", description: "\$${grandTotal.toString()}"),
                    const SizedBox(height: 18),
                    MaterialButton(
                      textColor: Colors.white,
                      minWidth: MediaQuery.of(context).size.width,
                      height: 70,
                      onPressed: () {
                        if (start == "Choose..." && end == "Choose...") {
                          NotificationService.showSnackBar(
                              "Please choose stations first");
                        } else {
                          customPushWithArgument(Routes.payment, {
                            "start": start,
                            "end": end,
                            "namestart": nameStart,
                            "nameend": nameEnd,
                            "passengers":
                                (passengers[0] + passengers[1]).toString(),
                            "price": grandTotal.toString()
                          });
                        }
                      },
                      color: primaryMedium,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        "Book Now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class CustomShape extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}

class PassengersCount extends StatefulWidget {

  final List list;

  const PassengersCount({Key? key, required this.list}) : super(key: key);

  @override
  State<PassengersCount> createState() => PassengersCountState();

}

class PassengersCountState extends State<PassengersCount> {

  Widget incrementButton(int index) {
    return FloatingActionButton.small(
      backgroundColor: Colors.white,
      onPressed: () {
        setState(() {
          widget.list[index]++;
        });
      },
      child: const Icon(FontAwesomeIcons.plus, color: Colors.black87, size: 24),
    );
  }

  Widget decrementButton(int index) {
    return FloatingActionButton.small(
        onPressed: () {
          setState(() {
            if (widget.list[index] > 0) {
              widget.list[index]--;
            }
          });
        },
        backgroundColor: Colors.white,
        child:
            const Icon(FontAwesomeIcons.minus, color: Colors.black, size: 24));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryMedium,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: primaryMedium,
        leading: CustomIconButton(
          color: Colors.white,
          icon: FontAwesomeIcons.arrowLeft,
          onPressed: () {
            Navigator.pop(context, widget.list);
          },
        ),
        title: const Text(
          "Passengers",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Stack(
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
              padding: const EdgeInsets.all(19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          " Adults",
                          style: TextStyle(
                              color: primaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      decrementButton(0),
                      const SizedBox(width: 30),
                      Text(
                        "${widget.list[0]}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 30),
                      incrementButton(0),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          " Children",
                          style: TextStyle(
                              color: primaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      decrementButton(1),
                      const SizedBox(width: 30),
                      Text(
                        "${widget.list[1]}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 30),
                      incrementButton(1),
                    ],
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
