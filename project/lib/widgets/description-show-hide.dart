import "package:flutter/material.dart";

import "buttons.dart";

class DescriptionShowHide extends StatefulWidget {

  final String text;

  const DescriptionShowHide({Key? key, required this.text}) : super(key: key);

  @override
  State<DescriptionShowHide> createState() => DescriptionShowHideState();

}

class DescriptionShowHideState extends State<DescriptionShowHide> {

  String firstHalf = "";
  String secondHalf = "";
  bool flag = true;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > 50) {
      firstHalf = widget.text.substring(0, 50);
      secondHalf = widget.text.substring(50, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return secondHalf.isEmpty
        ? Text(firstHalf)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(flag ? ("$firstHalf...") : (firstHalf + secondHalf)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomOutlineButton(
                      onPressed: () {
                        setState(() {
                          flag = !flag;
                        });
                      },
                      text: flag ? "Show more" : "Show less")
                ],
              ),
            ],
          );
  }

}
