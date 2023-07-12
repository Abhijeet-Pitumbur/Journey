import "package:animate_do/animate_do.dart";
import "package:dotted_line/dotted_line.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

import "helpers/colors.dart";

class TravelDetailsPanel extends StatefulWidget {
  const TravelDetailsPanel({Key? key}) : super(key: key);

  @override
  State<TravelDetailsPanel> createState() => _TravelDetailsPanelState();
}

class _TravelDetailsPanelState extends State<TravelDetailsPanel> {
  Widget alertCircle(Color color) {
    return CircleAvatar(
      radius: 9,
      backgroundColor: Colors.grey,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 8,
        child: CircleAvatar(
          radius: 5,
          backgroundColor: color,
        ),
      ),
    );
  }

  Widget dottedLine({double height = 80}) {
    return DottedLine(
      direction: Axis.vertical,
      lineLength: height,
      dashColor: Colors.grey,
    );
  }

  Widget headingTitle(String headingTile) {
    return Text(
      headingTile,
      style: TextStyle(
        color: Colors.grey.shade800,
        fontWeight: FontWeight.w900,
        fontSize: 18,
      ),
    );
  }

  Widget subTitle(String subTitle) {
    return Text(
      subTitle,
      style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 15,
          fontWeight: FontWeight.w800),
    );
  }

  Widget startTime(String startTime) {
    return Text(
      startTime,
      style:
          TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w900),
    );
  }

  Widget time(String time) {
    return Text(
      time,
      style: TextStyle(
          color: primaryMedium.withOpacity(0.8),
          fontSize: 16,
          fontWeight: FontWeight.w800),
    );
  }

  Widget startIcon(IconData iconData) {
    return Icon(
      iconData,
      color: Colors.grey.shade800,
    );
  }

  Widget tag(String tag, Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          tag,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget colorLine({required Color color, bool bottom = false}) {
    return Container(
      width: 15,
      height: 200,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(100)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5),
        child: Column(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)),
            ),
            const Spacer(),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionStyle1(
      bool isend,
      Widget startIcon,
      Widget startTime,
      Widget alertCircle,
      Widget dottedLine,
      Widget headingTitle,
      Widget subTitle,
      Widget time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [startIcon, const SizedBox(height: 4), startTime],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isend ? const SizedBox() : alertCircle,
              dottedLine,
              !isend ? const SizedBox() : alertCircle,
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingTitle,
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [subTitle, time],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget sectionStyle2(
      Widget startIcon,
      Widget tag,
      Widget startTime,
      Widget startIcon2,
      Widget startTime2,
      Widget colorLine,
      Widget headingTitle,
      Widget subTitle,
      Widget time,
      Widget headingTitle2,
      Widget subTitle2,
      Widget time2) {
    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                startIcon,
                const SizedBox(height: 4),
                tag,
                const SizedBox(height: 9),
                startTime,
                const Spacer(),
                startIcon2,
                const SizedBox(height: 4),
                startTime2,
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                colorLine,
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headingTitle,
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [subTitle, time],
                ),
                const Spacer(),
                headingTitle2,
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [subTitle2, time2],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionStyle3(
      bool isend,
      Widget startIcon,
      Widget startTime,
      Widget alertCircle,
      Widget dottedLine,
      Widget headingTitle,
      Widget subTitle,
      Widget time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const []),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isend ? const SizedBox() : alertCircle,
              dottedLine,
              !isend ? const SizedBox() : alertCircle,
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingTitle,
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 0),
          const SizedBox(height: 20),
          FadeInLeft(
            child: sectionStyle1(
                false,
                startIcon(FontAwesomeIcons.personWalking),
                startTime("14:20"),
                alertCircle(Colors.green.shade400),
                dottedLine(),
                headingTitle("Lorem St, 59"),
                subTitle("Walk 300 m"),
                time("4 mins")),
          ),
          FadeInRight(
            child: sectionStyle2(
                startIcon(FontAwesomeIcons.trainSubway),
                tag("M", primaryMedium),
                startTime("14:24"),
                startIcon(FontAwesomeIcons.personWalking),
                startTime("14:50"),
                colorLine(color: primaryMedium, bottom: false),
                headingTitle("Ipsum"),
                subTitle("9 stops"),
                time("26 mins"),
                headingTitle("Lorem"),
                subTitle("Walk 500 m"),
                time("6 mins")),
          ),
          FadeInDown(
            child: sectionStyle3(
                true,
                startIcon(FontAwesomeIcons.personWalking),
                startTime("14:56"),
                alertCircle(Colors.red.shade400),
                dottedLine(),
                headingTitle("Ipsum St, 23"),
                subTitle("Walk 120 m"),
                time("2 mins")),
          ),
        ],
      ),
    );
  }
}
