import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lali/models/booking.dart';

class BookingsBloc extends ChangeNotifier {
  final _fs = FirebaseFirestore.instance;
  final List<BookingModel> _items = [];
  List<BookingModel> get items => List.unmodifiable(_items);
  bool _loading = false;
  bool get loading => _loading;

  Future<void> fetchForUser(String userId) async {
    _loading = true;
    notifyListeners();
    try {
      final qs = await _fs
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      _items
        ..clear()
        ..addAll(qs.docs.map((d) => BookingModel.fromFirestore(d)));
    } catch (e) {
      if (kDebugMode) {
        print('BookingsBloc.fetchForUser error: $e');
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<String?> createPending({
    required String userId,
    required String type,
    required String refId,
    required String placeId,
    required num amount,
    String currency = 'INR',
    Map<String, dynamic>? payload,
  }) async {
    try {
      final doc = await _fs.collection('bookings').add({
        'userId': userId,
        'type': type,
        'refId': refId,
        'placeId': placeId,
        'amount': amount,
        'currency': currency,
        'status': 'pending',
        'payload': payload,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return doc.id;
    } catch (e) {
      if (kDebugMode) {
        print('BookingsBloc.createPending error: $e');
      }
      return null;
    }
  }

  Future<void> markConfirmed(String bookingId, {String? txnId}) async {
    await _fs.collection('bookings').doc(bookingId).update({
      'status': 'confirmed',
      if (txnId != null) 'payment': {'status': 'success', 'txnId': txnId}
    });
  }
}
