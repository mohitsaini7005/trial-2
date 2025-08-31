import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/models/place.dart';
import 'package:lali/core/services/region_prefs.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RecommandedPlacesBloc extends ChangeNotifier{

  List<Place> _data = [];
  List<Place> get data => _data;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;



  Future getData() async {
    final country = await RegionPrefs.getCountry();
    Query query = firestore.collection('places');
    if (country != 'GLOBAL') {
      query = query.where('country', isEqualTo: country);
    }
    final rc = FirebaseRemoteConfig.instance;
    final int limit = rc.getInt('max_places_per_list') == 0 ? 5 : rc.getInt('max_places_per_list');
    final QuerySnapshot rawData = await query
        .orderBy('comments count', descending: true)
        .limit(limit)
        .get();

    List<DocumentSnapshot> snapList = [];
    snapList.addAll(rawData.docs);
    _data = snapList.map((e) => Place.fromFirestore(e)).toList();
    notifyListeners();


  }

  onRefresh(mounted) {
    _data.clear();
    getData();
    notifyListeners();
  }








}