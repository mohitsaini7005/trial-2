import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/place.dart';
import 'package:lali/core/services/region_prefs.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';


class OtherPlacesBloc extends ChangeNotifier{

  List<Place> _data = [];
  List<Place> get data => _data;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future getData(String stateName, String timestamp) async {
    _data.clear();
    final country = await RegionPrefs.getCountry();
    Query query = firestore
        .collection('places')
        .where('state', isEqualTo: stateName);
    if (country != 'GLOBAL') {
      query = query.where('country', isEqualTo: country);
    }
    final rc = FirebaseRemoteConfig.instance;
    final int limit = rc.getInt('max_places_per_list') == 0 ? 6 : rc.getInt('max_places_per_list');
    final QuerySnapshot rawData = await query
        .orderBy('loves', descending: true)
        .limit(limit)
        .get();

    List<DocumentSnapshot> snap = [];
    snap.addAll(rawData.docs.skipWhile((value) => value['timestamp'] == timestamp));
    _data = snap.map((e) => Place.fromFirestore(e)).toList();
    notifyListeners();


  }

  onRefresh(mounted, String stateName, String timestamp) {
    _data.clear();
    getData(stateName, timestamp);
    notifyListeners();
  }

}