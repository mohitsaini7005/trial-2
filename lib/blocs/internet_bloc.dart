import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetBloc extends ChangeNotifier{
  bool _hasInternet = false;


  InternetBloc(){
    checkInternet();
  }

  set hasInternet (newVal){
    _hasInternet = newVal;
  }

  bool get hasInternet => _hasInternet;

  checkInternet() async {
    // connectivity_plus ^6.x returns a List<ConnectivityResult>
    final results = await Connectivity().checkConnectivity();
    // Consider we have internet if any result is not 'none'
    final hasAnyConnection = results.any((r) => r != ConnectivityResult.none);
    _hasInternet = hasAnyConnection;

    notifyListeners();
  }


}