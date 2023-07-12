import "dart:ui";

import "package:google_maps_flutter/google_maps_flutter.dart";

class PinInformation {

  String pinPath;
  String iconPath;
  LatLng location;
  String locationName;
  Color labelColor;

  PinInformation(
      {required this.pinPath,
      required this.iconPath,
      required this.location,
      required this.locationName,
      required this.labelColor});

}
