import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import '../core/config/config.dart';
import '../core/utils/convert_map_icon.dart';
import '../models/hotel.dart';
import '../models/place.dart';

class HotelPage extends StatefulWidget {
  final Place placeData;

  const HotelPage({super.key, required this.placeData});

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  late GoogleMapController _controller;
  final List<Hotel> _alldata = [];
  late PageController _pageController;
  late int prevPage;
  final List<Marker> _markers = [];
  late Uint8List _customMarkerIcon;

  void openEmptyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("we didn't find any nearby hotels in this area").tr(),
          title: const Text('no hotels found', style: TextStyle(fontWeight: FontWeight.w700),).tr(),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  Future<void> getData() async {
    http.Response response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${widget.placeData.latitude},${widget.placeData.longitude}&radius=3000&type=hotel&keyword=hotel&key=${Config().mapAPIKey}',
      ),
    );

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      if (decodedData['results'].isEmpty) {
        openEmptyDialog();
      } else {
        for (var i = 0; i < decodedData['results'].length; i++) {
          Hotel d = Hotel(
            decodedData['results'][i]['name'],
            decodedData['results'][i]['vicinity'] ?? '',
            decodedData['results'][i]['geometry']['location']['lat'] ?? 0.0,
            decodedData['results'][i]['geometry']['location']['lng'] ?? 0.0,
            decodedData['results'][i]['rating'] ?? 4,
            decodedData['results'][i]['price_level'] ?? 0,
          );

          _alldata.add(d);
          _alldata.sort((a, b) => b.rating.compareTo(a.rating));
        }
      }
    }
  }

  Future<void> setMarkerIcon() async {
    _customMarkerIcon = await getBytesFromAsset(Config().hotelPinIcon, 100);
  }

  void _addMarker() {
    for (var data in _alldata) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(data.name),
            position: LatLng(data.lat, data.lng),
            infoWindow: InfoWindow(title: data.name, snippet: data.address),
            icon: BitmapDescriptor.fromBytes(_customMarkerIcon),
            onTap: () {},
          ),
        );
      });
    }
  }

  void _onScroll() {
    if (_pageController.page?.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      moveCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
    setMarkerIcon();
    getData().then((value) {
      animateCameraAfterInitialization();
      _addMarker();
    });
  }

  Widget _hotelList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget? widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 140.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          _onCardTap(index);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  right: 10,
                ),
                padding: const EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 0.5, color: Colors.grey[500]!),
                ),
                child: Image.asset(Config().hotelIcon),
              ),
              Flexible(
                child: Wrap(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      _alldata[index].name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _alldata[index].address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                          width: 90,
                          child: ListView.builder(
                            itemCount: _alldata[index].rating.round(),
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return const Icon(
                                LineIcons.star,
                                color: Colors.orangeAccent,
                                size: 16,
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          '(${_alldata[index].rating})',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCardTap(index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 15, top: 10, right: 5),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.orangeAccent,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Image(
                          image: AssetImage(Config().hotelIcon),
                          height: 120,
                          width: 120,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            _alldata[index].name,
                            style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 5),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.location_on,
                            color: Colors.orangeAccent,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              _alldata[index].address,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.star,
                            color: Colors.orangeAccent,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Rating : ${_alldata[index].rating}/5',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.opacity,
                            color: Colors.orangeAccent,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                                _alldata[index].price == 0
                                    ? 'Price : Moderate'
                                    : _alldata[index].price == 1
                                    ? 'Price : Inexpensive'
                                    : _alldata[index].price == 2
                                    ? 'Price : Moderate'
                                    : _alldata[index].price == 3
                                    ? 'Price : Expensive'
                                    : 'Price : Very Expensive',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.bottomRight,
                  height: 50,
                  child: TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                compassEnabled: false,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: Config().initialCameraPosition,
                cameraTargetBounds: CameraTargetBounds(
                  LatLngBounds(
                    southwest: const LatLng(6.5546079, 68.1113787),
                    northeast: const LatLng(35.6745457, 97.3955610),
                  ),
                ),
                markers: Set.from(_markers),
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    _controller = controller;
                  });
                },
              ),
            ),
            _alldata.isEmpty
                ? const SizedBox.shrink()
                : Positioned(
              bottom: 10.0,
              child: SizedBox(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _alldata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _hotelList(index);
                  },
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: 10,
              child: Row(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey[300]!,
                            blurRadius: 10,
                            offset: const Offset(3, 3),
                          )
                        ],
                      ),
                      child: const Icon(Icons.keyboard_backspace),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey, width: 0.5)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 10, bottom: 10, right: 15),
                      child: Text(
                        '${widget.placeData.name} - Nearby Hotels',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            _alldata.isEmpty
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

  void mapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  void animateCameraAfterInitialization() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(widget.placeData.latitude, widget.placeData.longitude),
      zoom: 13,
    )));
  }

  void moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_alldata[_pageController.page!.toInt()].lat,
          _alldata[_pageController.page!.toInt()].lng),
      zoom: 20,
      bearing: 45.0,
      tilt: 45.0,
    )));
  }
}
