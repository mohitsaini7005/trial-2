import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingType { stay, food, event }

enum BookingStatus { pending, confirmed, canceled, refunded }

class BookingModel {
  final String id;
  final String userId;
  final BookingType type;
  final String refId; // eventId/stayId/foodId
  final String placeId;
  final DateTime createdAt;
  final BookingStatus status;
  final num amount;
  final String currency;
  final Map<String, dynamic>? payload; // tickets, dates, etc.

  BookingModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.refId,
    required this.placeId,
    required this.createdAt,
    required this.status,
    required this.amount,
    required this.currency,
    this.payload,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot snap) {
    final d = snap.data() as Map<String, dynamic>?;
    if (d == null) throw StateError('Null booking doc');
    return BookingModel(
      id: snap.id,
      userId: d['userId'] ?? '',
      type: _typeFromString(d['type']?.toString() ?? 'event'),
      refId: d['refId'] ?? '',
      placeId: d['placeId'] ?? '',
      createdAt: (d['createdAt'] is Timestamp)
          ? (d['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(d['createdAt']?.toString() ?? '') ?? DateTime.now(),
      status: _statusFromString(d['status']?.toString() ?? 'pending'),
      amount: (d['amount'] as num?) ?? 0,
      currency: d['currency'] ?? 'INR',
      payload: d['payload'] as Map<String, dynamic>?,
    );
  }

  static BookingType _typeFromString(String s) {
    switch (s) {
      case 'stay':
        return BookingType.stay;
      case 'food':
        return BookingType.food;
      default:
        return BookingType.event;
    }
  }

  static BookingStatus _statusFromString(String s) {
    switch (s) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'canceled':
        return BookingStatus.canceled;
      case 'refunded':
        return BookingStatus.refunded;
      default:
        return BookingStatus.pending;
    }
  }
}
