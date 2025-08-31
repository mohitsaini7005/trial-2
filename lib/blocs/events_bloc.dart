import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lali/models/event.dart';

class EventsBloc extends ChangeNotifier {
  final _fs = FirebaseFirestore.instance;
  final List<EventModel> _events = [];
  List<EventModel> get events => List.unmodifiable(_events);
  bool _loading = false;
  bool get loading => _loading;

  Future<void> fetchByPlace(String placeId) async {
    _loading = true;
    notifyListeners();
    try {
      final qs = await _fs
          .collection('events')
          .where('placeId', isEqualTo: placeId)
          .orderBy('start')
          .get();
      _events
        ..clear()
        ..addAll(qs.docs.map((d) => EventModel.fromFirestore(d)));
    } catch (e) {
      if (kDebugMode) {
        print('EventsBloc.fetchByPlace error: $e');
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUpcoming({int limit = 20}) async {
    _loading = true;
    notifyListeners();
    try {
      final now = Timestamp.fromDate(DateTime.now());
      final qs = await _fs
          .collection('events')
          .where('start', isGreaterThanOrEqualTo: now)
          .orderBy('start')
          .limit(limit)
          .get();
      _events
        ..clear()
        ..addAll(qs.docs.map((d) => EventModel.fromFirestore(d)));
    } catch (e) {
      if (kDebugMode) {
        print('EventsBloc.fetchUpcoming error: $e');
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
