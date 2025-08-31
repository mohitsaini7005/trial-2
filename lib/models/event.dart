import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String placeId;
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final List<String> images;
  final List<TicketTier> ticketTiers;

  EventModel({
    required this.id,
    required this.placeId,
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.images,
    required this.ticketTiers,
  });

  factory EventModel.fromFirestore(DocumentSnapshot snap) {
    final d = snap.data() as Map<String, dynamic>?;
    if (d == null) throw StateError('Null event doc');
    final tiers = (d['ticketTiers'] as List?)
            ?.map((e) => TicketTier.fromMap(e as Map<String, dynamic>))
            .toList() ??
        <TicketTier>[];
    return EventModel(
      id: snap.id,
      placeId: d['placeId'] ?? '',
      title: d['title'] ?? '',
      description: d['description'] ?? '',
      start: (d['start'] is Timestamp)
          ? (d['start'] as Timestamp).toDate()
          : DateTime.tryParse(d['start']?.toString() ?? '') ?? DateTime.now(),
      end: (d['end'] is Timestamp)
          ? (d['end'] as Timestamp).toDate()
          : DateTime.tryParse(d['end']?.toString() ?? '') ?? DateTime.now(),
      images: (d['images'] as List?)?.cast<String>() ?? <String>[],
      ticketTiers: tiers,
    );
  }
}

class TicketTier {
  final String name;
  final num price;
  final int qty;

  TicketTier({required this.name, required this.price, required this.qty});

  factory TicketTier.fromMap(Map<String, dynamic> m) {
    return TicketTier(
      name: m['name'] ?? '',
      price: (m['price'] as num?) ?? 0,
      qty: (m['qty'] as num?)?.toInt() ?? 0,
    );
  }
}
