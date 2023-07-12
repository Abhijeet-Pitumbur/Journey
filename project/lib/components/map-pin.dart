import "package:flutter/material.dart";

import "../models/map-pin-info.dart";

// ignore: must_be_immutable
class MapPinComponent extends StatefulWidget {

  double pinPosition;
  PinInformation currentPin;

  MapPinComponent(
      {Key? key,
      required this.pinPosition,
      required this.currentPin})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => MapPinComponentState();

}

class MapPinComponentState extends State<MapPinComponent> {

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: widget.pinPosition,
      right: 0,
      left: 0,
      duration: const Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.all(20),
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  blurRadius: 20,
                  offset: Offset.zero,
                  color: Colors.grey.withOpacity(0.5))
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(left: 10),
                child: ClipOval(
                  child: Image.asset(widget.currentPin.iconPath,
                      fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.currentPin.locationName,
                        style: TextStyle(
                            color: widget.currentPin.labelColor),
                      ),
                      Text(
                        "Latitude: ${widget.currentPin.location.latitude.toString()}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "Longitude: ${widget.currentPin.location.longitude.toString()}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset(widget.currentPin.pinPath,
                    width: 50, height: 50),
              )
            ],
          ),
        ),
      ),
    );
  }

}
