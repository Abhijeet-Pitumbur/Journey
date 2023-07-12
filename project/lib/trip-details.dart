// ignore_for_file: constant_identifier_names
import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_polyline_points/flutter_polyline_points.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:journey/trip-details-drawer.dart";
import "package:journey/widgets/buttons.dart";
import "package:permission_handler/permission_handler.dart";
import "package:sliding_up_panel/sliding_up_panel.dart";

import "helpers/colors.dart";
import "models/map-pin-info.dart";

const double cameraZoom = 13;
const double cameraTilt = 0;
const double cameraBearing = 30;
const LatLng startLocation = LatLng(-20.240, 57.476);
const LatLng endLocation = LatLng(-20.220, 57.468);

class TripDetails extends StatefulWidget {

  const TripDetails({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TripDetailsState();

}

class TripDetailsState extends State<TripDetails> {

  final Completer<GoogleMapController> completer = Completer();
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  final Set<Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polyLinePoints = PolylinePoints();
  String googleApiKey = "AIzaSyCAAGeeal5has34F8XDKYo3LeVK4OHCiDc";
  late BitmapDescriptor startIcon;
  late BitmapDescriptor endIcon;
  double pinPosition = -100;
  PinInformation currentPin = PinInformation(
      pinPath: "",
      iconPath: "",
      location: const LatLng(0, 0),
      locationName: "",
      labelColor: Colors.grey);
  late PinInformation startPinInfo;
  late PinInformation endPinInfo;
  bool panelState = false;
  String start = "";
  String end = "";
  String nameStart = "";
  String nameEnd = "";
  String passengers = "";
  String price = "";

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

  Future checkForPermissions() async {
    final PermissionStatus permission = await getPermission();
    if (permission == PermissionStatus.granted) {
      setMapPins();
    } else if (permission == PermissionStatus.denied) {
      setMapPins();
    }
  }

  Future<PermissionStatus> getPermission() async {
    final PermissionStatus permission = await Permission.location.status;
    if (permission != PermissionStatus.granted ||
        permission == PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus = await [
        Permission.location,
      ].request();
      return permissionStatus[Permission.location] ??
          PermissionStatus.restricted;
    } else {
      return permission;
    }
  }

  Future setStartAndEndIcons() async {
    startIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        "images/trip-start.png");
    endIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), "images/trip-end.png");
  }

  Future setMapPins() async {
    await setStartAndEndIcons();
    markers.add(Marker(
        markerId: const MarkerId("startPin"),
        position: startLocation,
        onTap: () {
          setState(() {
            currentPin = startPinInfo;
            pinPosition = 0;
          });
        },
        icon: startIcon));
    startPinInfo = PinInformation(
        locationName: "Start Location",
        location: startLocation,
        pinPath: "images/trip-start.png",
        iconPath: "",
        labelColor: Colors.blueAccent);
    markers.add(Marker(
        markerId: const MarkerId("endPin"),
        position: endLocation,
        onTap: () {
          setState(() {
            currentPin = endPinInfo;
            pinPosition = 0;
          });
        },
        icon: endIcon));
    await setPolyLines();
    double minY = (startLocation.latitude <= endLocation.latitude)
        ? startLocation.latitude
        : endLocation.latitude;
    double minX = (startLocation.longitude <= endLocation.longitude)
        ? startLocation.longitude
        : endLocation.longitude;
    double maxY = (startLocation.latitude <= endLocation.latitude)
        ? endLocation.latitude
        : startLocation.latitude;
    double maxX = (startLocation.longitude <= endLocation.longitude)
        ? endLocation.longitude
        : startLocation.longitude;
    double southWestLatitude = minY;
    double southWestLongitude = minX;
    double northEastLatitude = maxY;
    double northEastLongitude = maxX;
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        150.0,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utilities.mapStyles);
    completer.complete(controller);
    mapController = controller;
  }

  Widget moveToEnd() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          child: Text(
            start,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
        ),
        const SizedBox(width: 10),
        const Icon(FontAwesomeIcons.arrowRight),
        const SizedBox(width: 10),
        SizedBox(
          child: Text(
            end,
            textAlign: TextAlign.end,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
          ),
        ),
      ],
    );
  }

  Widget shortDetail(bool hideButton) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Leaving in",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "12 ",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
                    ),
                    TextSpan(
                      text: "mins",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "36 mins travel time",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              moveToEnd(),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Price",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Text(
                "\u0024$price",
                textAlign: TextAlign.end,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
          hideButton ? const SizedBox() : const Spacer(),
          InkWell(
            onTap: () {
              panelState ? panelController.close() : panelController.open();
            },
            child: CircleAvatar(
              backgroundColor:
                  panelState ? Colors.red.withOpacity(0.1) : primaryMedium,
              foregroundColor: panelState ? Colors.red : Colors.white,
              child: Icon(panelState
                  ? FontAwesomeIcons.arrowDown
                  : FontAwesomeIcons.arrowUp),
            ),
          ),
        ],
      ),
    );
  }

  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = const CameraPosition(
        zoom: cameraZoom,
        bearing: cameraBearing,
        tilt: cameraTilt,
        target: startLocation);
    return Scaffold(
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
          "Trip Details",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SlidingUpPanel(
        controller: panelController,
        maxHeight: 650,
        onPanelClosed: () {
          setState(() {
            panelState = false;
          });
        },
        onPanelOpened: () {
          setState(() {
            panelState = true;
          });
        },
        backdropEnabled: false,
        header: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                child: Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                ),
              ),
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
              child: FutureBuilder(
                future: checkForPermissions(),
                builder: (context, snapshot) => Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GoogleMap(
                        myLocationEnabled: false,
                        compassEnabled: false,
                        tiltGesturesEnabled: true,
                        markers: markers,
                        polylines: polyLines,
                        mapType: MapType.normal,
                        initialCameraPosition: initialLocation,
                        onMapCreated: onMapCreated,
                        onTap: (LatLng location) {
                          setState(() {
                            pinPosition = -100;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        collapsed: shortDetail(false),
        panel: Column(
          children: [shortDetail(false), const TravelDetailsPanel()],
        ),
      ),
    );
  }

  setPolyLines() async {
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(startLocation.latitude, startLocation.longitude),
        PointLatLng(endLocation.latitude, endLocation.longitude),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Phoenix, Mauritius")]);
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      Polyline polyline = Polyline(
          polylineId: const PolylineId("polyLine"),
          color: const Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);
      polyLines.add(polyline);
      setState(() {});
    }
  }

}

class Utilities {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#F5F5F5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#F5F5F5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#BDBDBD"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#EEEEEE"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#E5E5E5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9E9E9E"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#FFFFFF"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#DADADA"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9E9E9E"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#E5E5E5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#EEEEEE"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#C9C9C9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9E9E9E"
      }
    ]
  }
]''';
}
