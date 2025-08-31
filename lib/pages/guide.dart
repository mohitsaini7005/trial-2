import 'dart:async';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:easy_localization/easy_localization.dart';

import '../core/config/config.dart';
import '../core/utils/convert_map_icon.dart';
import '../core/utils/map_util.dart';
import '../core/utils/formatting.dart';
import '../models/colors.dart';
import '../models/place.dart';

class GuidePage extends StatefulWidget {
  final Place d;

  const GuidePage({super.key, required this.d});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  late GoogleMapController mapController;

  final List<Marker> _markers = [];
  Map<String, dynamic> data = {};
  String distance = '0 km';

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  late Uint8List _sourceIcon;
  late Uint8List _destinationIcon;

  Future<void> getData() async {
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('places')
        .doc(widget.d.timestamp)
        .collection('travel guide')
        .doc(widget.d.timestamp)
        .get();
    if (!mounted) return;
    setState(() {
      data = snap.data() as Map<String, dynamic>? ?? {};
    });
  }

  Future<void> _setMarkerIcons() async {
    _sourceIcon = await getBytesFromAsset(Config().drivingMarkerIcon, 110);
    _destinationIcon = await getBytesFromAsset(Config().destinationMarkerIcon, 110);
  }

  Future<void> addMarker() async {
    final List<Marker> m = [
      Marker(
        markerId: MarkerId(data['startpoint name']),
        position: LatLng(data['startpoint lat'], data['startpoint lng']),
        infoWindow: InfoWindow(title: data['startpoint name']),
        icon: BitmapDescriptor.fromBytes(_sourceIcon),
      ),
      Marker(
        markerId: MarkerId(data['endpoint name']),
        position: LatLng(data['endpoint lat'], data['endpoint lng']),
        infoWindow: InfoWindow(title: data['endpoint name']),
        icon: BitmapDescriptor.fromBytes(_destinationIcon),
      )
    ];
    if (!mounted) return;
    setState(() {
      _markers.addAll(m);
    });
  }

  Future<void> _addSeededPlaceMarkers() async {
    try {
      final qs = await FirebaseFirestore.instance
          .collection('places')
          .where('country', isEqualTo: 'IN')
          .limit(50)
          .get();
      final List<Marker> extra = qs.docs.map((d) {
        final data = d.data();
        final double lat = (data['lat'] as num).toDouble();
        final double lng = (data['lng'] as num).toDouble();
        final String name = (data['name_en'] ?? data['name'] ?? d.id).toString();
        return Marker(
          markerId: MarkerId('place_${d.id}'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        );
      }).toList();
      if (!mounted) return;
      setState(() {
        _markers.addAll(extra);
      });
    } catch (_) {
      // ignore errors from optional overlay
    }
  }

  Future<void> computeDistance() async {
    // Calculate haversine distance between start and end points in kilometers
    try {
      final double lat1 = (data['startpoint lat'] as num).toDouble();
      final double lon1 = (data['startpoint lng'] as num).toDouble();
      final double lat2 = (data['endpoint lat'] as num).toDouble();
      final double lon2 = (data['endpoint lng'] as num).toDouble();

      double deg2rad(double deg) => deg * (math.pi / 180.0);

      final double dLat = deg2rad(lat2 - lat1);
      final double dLon = deg2rad(lon2 - lon1);
      final double a =
          math.sin(dLat / 2) * math.sin(dLat / 2) +
              math.cos(deg2rad(lat1)) *
                  math.cos(deg2rad(lat2)) *
                  math.sin(dLon / 2) *
                  math.sin(dLon / 2);
      final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
      const double earthRadiusKm = 6371.0;
      final double km = earthRadiusKm * c;

      if (!mounted) return;
      setState(() {
        distance = '${km.toStringAsFixed(1)} km';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        distance = '0 km';
      });
    }
  }

  Future<void> _getPolyline() async {
    final PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Config().mapAPIKey,
      PointLatLng(data['startpoint lat'], data['startpoint lng']),
      PointLatLng(data['endpoint lat'], data['endpoint lng']),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (final PointLatLng point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }

  void _addPolyLine() {
    const PolylineId id = PolylineId("poly");
    final Polyline polyline = Polyline(
      polylineId: id,
      color: const Color.fromARGB(255, 40, 122, 198),
      points: polylineCoordinates,
    );
    polylines[id] = polyline;
    if (!mounted) return;
    setState(() {});
  }

  void animateCamera() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(data['startpoint lat'], data['startpoint lng']),
          zoom: 8,
          bearing: 120,
        ),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(MapUtils.mapStyles);
    if (!mounted) return;
    setState(() {
      mapController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    _setMarkerIcons();
    getData().then((value) {
      addMarker().then((value) {
        _getPolyline();
        computeDistance();
        animateCamera();
      });
    });
    _addSeededPlaceMarkers();
  }

  Widget panelUI() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "travel guide",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ).tr(),
          ],
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            text: 'estimated cost = '.tr(),
            children: <TextSpan>[
              TextSpan(
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                text: () {
                  final dynamic p = data['price'];
                  if (p is num) {
                    return Formatting.currencyINR(p.toDouble(), locale: context.locale);
                  }
                  if (p is String) {
                    final v = double.tryParse(p.replaceAll(RegExp(r'[^0-9\.]'), ''));
                    if (v != null) {
                      return Formatting.currencyINR(v, locale: context.locale);
                    }
                    return p;
                  }
                  return '';
                }(),
              )
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            text: 'distance = '.tr(),
            children: <TextSpan>[
              TextSpan(
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                text: distance,
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          height: 3,
          width: 170,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'steps',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ).tr(),
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                height: 3,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: data.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 10),
                  itemCount: data['paths'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: ColorList().guideColors[index],
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(height: 90, width: 2, color: Colors.black12)
                            ],
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              data['paths'][index] ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox.shrink();
                  },
                ),
        ),
      ],
    );
  }

  Widget panelBodyUI(double h, double w) {
    final bool lowEnd = FirebaseRemoteConfig.instance.getBool('low_end_map_mode');
    return SizedBox(
      width: w,
      child: GoogleMap(
        initialCameraPosition: Config().initialCameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) => onMapCreated(controller),
        markers: Set.from(_markers),
        polylines: Set<Polyline>.of(polylines.values),
        compassEnabled: !lowEnd,
        myLocationEnabled: false,
        zoomGesturesEnabled: !lowEnd,
        tiltGesturesEnabled: !lowEnd,
        rotateGesturesEnabled: !lowEnd,
        myLocationButtonEnabled: !lowEnd,
        mapToolbarEnabled: !lowEnd,
        cameraTargetBounds: CameraTargetBounds(
          LatLngBounds(
            southwest: const LatLng(6.5546079, 68.1113787),
            northeast: const LatLng(35.6745457, 97.3955610),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SlidingUpPanel(
              minHeight: 125,
              maxHeight: MediaQuery.of(context).size.height * 0.80,
              backdropEnabled: true,
              backdropOpacity: 0.2,
              backdropTapClosesPanel: true,
              isDraggable: true,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                  offset: Offset(1, 0),
                ),
              ],
              padding: const EdgeInsets.only(top: 15, left: 10, bottom: 0, right: 10),
              panel: panelUI(),
              body: panelBodyUI(h, w),
            ),
            Positioned(
              top: 15,
              left: 10,
              child: SizedBox(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.keyboard_backspace),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    data.isEmpty
                        ? const SizedBox.shrink()
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey, width: 0.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                top: 10,
                                bottom: 10,
                                right: 15,
                              ),
                              child: Text(
                                '${data['startpoint name']} - ${data['endpoint name']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            data.isEmpty && polylines.isEmpty
                ? const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
