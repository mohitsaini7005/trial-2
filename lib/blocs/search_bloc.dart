import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/place.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class SearchBloc with ChangeNotifier {


  SearchBloc (){
    getRecentSearchList();
  }


  List<String> _recentSearchData = [];
  List<String> get recentSearchData => _recentSearchData;

  String _searchText = '';
  String get searchText => _searchText;


  bool _searchStarted = false;
  bool get searchStarted => _searchStarted;


  final TextEditingController _textFieldCtrl = TextEditingController();
  TextEditingController get textfieldCtrl => _textFieldCtrl;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;




  Future getRecentSearchList() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData = sp.getStringList('recent_search_data') ?? [];
    notifyListeners();
  }


  Future addToSearchList (String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData.add(value);
    await sp.setStringList('recent_search_data', _recentSearchData);
    notifyListeners();
  }



  Future removeFromSearchList (String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData.remove(value);
    await sp.setStringList('recent_search_data', _recentSearchData);
    notifyListeners();
  }





  Future<List> getData() async {

    List<Place> data = [];
    QuerySnapshot rawData = await firestore
        .collection('places')
        .orderBy('timestamp', descending: true)
        .get();

    List<DocumentSnapshot> snapList = [];
    snapList.addAll(rawData.docs
        .where((u) => (

        u['place name'].toLowerCase().contains(_searchText.toLowerCase()) ||
            u['location'].toLowerCase().contains(_searchText.toLowerCase())

    )));
    data = snapList.map((e) => Place.fromFirestore(e)).toList();
    // Analytics event: search_performed
    try {
      await FirebaseAnalytics.instance.logEvent(name: 'search_performed', parameters: {
        'query_length': _searchText.length,
        'results_count': data.length,
      });
      FirebaseCrashlytics.instance.log('Search performed qlen=${_searchText.length} results=${data.length}');
    } catch (_) {
      // ignore analytics errors
    }
    return data;


  }





  setSearchText (value){
    _textFieldCtrl.text = value;
    _searchText = value;
    _searchStarted = true;
    notifyListeners();
  }


  saerchInitialize (){
    _textFieldCtrl.clear();
    _searchStarted = false;
    notifyListeners();

  }




}
