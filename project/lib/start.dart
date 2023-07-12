import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:journey/helpers/colors.dart";

import "authentication.dart";

class Start extends StatefulWidget {

  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => StartState();

}

class StartState extends State<Start> {

  List<String> image = [
    "images/start-first.png",
    "images/start-second.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(children: [
          Flexible(
              child: Stack(children: [
            Container(
              color: primaryDark,
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(100)),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: <Widget>[
                    const Text(
                      "WELCOME TO",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                        color: primaryDark,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SvgPicture.asset(
                      "images/logo-dark.svg",
                      width: 200,
                      color: primaryDark,
                    ),
                    const SizedBox(height: 30),
                    CarouselSlider.builder(
                      options: CarouselOptions(
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          enlargeCenterPage: true,
                          height: 230.0,
                          autoPlay: true,
                          viewportFraction: 1),
                      itemCount: image.length,
                      itemBuilder:
                          (BuildContext context, int i, int pageViewIndex) =>
                              Container(
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(image[i])),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ])),
          Flexible(
            child: Stack(children: [
              Container(color: Colors.white),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: primaryDark,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(100)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Let's get going!",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 35),
                      Text(
                        "Booking your metro tickets\nnow easier than ever before!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 30),
                      MaterialButton(
                        textColor: Colors.white,
                        minWidth: 300,
                        height: 60,
                        onPressed: () {
                          authenticationPopup(true);
                        },
                        color: primaryMedium,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 30),
                      MaterialButton(
                        textColor: primaryMedium,
                        minWidth: 300,
                        height: 60,
                        onPressed: () {
                          authenticationPopup(false);
                        },
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          )
        ]),
      ),
    );
  }

}
