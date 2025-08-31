import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/notification.dart';
import '/pages/notifications.dart';
import '/core/utils/next_screen.dart';

class NotificationBloc extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  DocumentSnapshot? _lastVisible;
  //DocumentSnapshot get lastVisible => _lastVisible;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  final List<DocumentSnapshot> _snap = List<DocumentSnapshot>.empty(growable: true);

  List<NotificationModel> _data = [];
  List<NotificationModel> get data => _data;

  bool _subscribed = false;
  bool get subscribed => _subscribed;

  final String subscriptionTopic = 'all';

  Future<void> getData(mounted) async {
    QuerySnapshot rawData;
    if (_lastVisible == null) {
      rawData = await firestore
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
    } else {
      rawData = await firestore
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible!['timestamp']])
          .limit(10)
          .get();
    }

    if (rawData.docs.isNotEmpty) {
      _lastVisible = rawData.docs[rawData.docs.length - 1];
      if (mounted) {
        _isLoading = false;
        _snap.addAll(rawData.docs);
        _data = _snap.map((e) => NotificationModel.fromFirestore(e)).toList();
      }
    } else {
      _isLoading = false;
      debugPrint('none');
    }

    notifyListeners();
    return;
  }

  setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }

  onRefresh(mounted) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    _lastVisible = null;
    getData(mounted);
    notifyListeners();
  }

  onReload(mounted) {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    _lastVisible = null;
    getData(mounted);
    notifyListeners();
  }

  Future initFirebasePushNotification(context) async {
    if (!kIsWeb && Platform.isIOS) {
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint('User granted permission: ${settings.authorizationStatus}');
    }

    handleFcmSubscribtion();

    if (!kIsWeb) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint("onMessage: $message");
        showinAppDialog(context, message.notification!.title, message.notification!.body);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint("onMessageOpenedApp: $message");
        nextScreen(context, const NotificationsPage());
      });
    }

    notifyListeners();
  }

  Future handleFcmSubscribtion() async {
    if (kIsWeb) {
      // Web push requires additional setup; default to unsubscribed/no-op
      _subscribed = false;
      notifyListeners();
      return;
    }
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool getSubscription = sp.getBool('subscribe') ?? true;
    if (getSubscription == true) {
      await sp.setBool('subscribe', true);
      _fcm.subscribeToTopic(subscriptionTopic);
      _subscribed = true;
      debugPrint('subscribed');
    } else {
      await sp.setBool('subscribe', false);
      _fcm.unsubscribeFromTopic(subscriptionTopic);
      _subscribed = false;
      debugPrint('unsubscribed');
    }

    notifyListeners();
  }


  Future fcmSubscribe(bool isSubscribed) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('subscribe', isSubscribed);
    handleFcmSubscribtion();
  }

  







  showinAppDialog(context, title, body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(title),
          subtitle: Html(data: body),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                nextScreen(context, const NotificationsPage());
              }),
        ],
      ),
    );
  }
}