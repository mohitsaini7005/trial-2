import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class SeedIndia {
  static const String assetPath = 'assets/seed/india_seed.json';

  /// One-shot seeding. Safe to re-run; uses set with merge:true on IDs when present.
  static Future<void> run() async {
    final fs = FirebaseFirestore.instance;
    final raw = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> data = json.decode(raw) as Map<String, dynamic>;

    final List states = (data['states'] as List?) ?? [];
    final List tribes = (data['tribes'] as List?) ?? [];
    final List festivals = (data['festivals'] as List?) ?? [];
    final List places = (data['places'] as List?) ?? [];

    // States
    for (final s in states) {
      final Map<String, dynamic> m = Map<String, dynamic>.from(s as Map);
      final String code = (m['code'] ?? '').toString();
      if (code.isEmpty) continue;
      await fs.collection('states').doc(code).set(m, SetOptions(merge: true));
    }

    // Tribes
    for (final t in tribes) {
      final Map<String, dynamic> m = Map<String, dynamic>.from(t as Map);
      final String id = (m['id'] ?? '').toString();
      if (id.isEmpty) continue;
      await fs.collection('tribes').doc(id).set(m, SetOptions(merge: true));
    }

    // Festivals
    for (final f in festivals) {
      final Map<String, dynamic> m = Map<String, dynamic>.from(f as Map);
      final String id = (m['id'] ?? '').toString();
      if (id.isEmpty) continue;
      await fs.collection('festivals').doc(id).set(m, SetOptions(merge: true));
    }

    // Places
    for (final p in places) {
      final Map<String, dynamic> m = Map<String, dynamic>.from(p as Map);
      final String id = (m['id'] ?? '').toString();
      if (id.isEmpty) continue;
      // Also keep a human-friendly 'name' field for UI fallbacks
      if (!m.containsKey('name') && m.containsKey('name_en')) {
        m['name'] = m['name_en'];
      }
      await fs.collection('places').doc(id).set(m, SetOptions(merge: true));
    }
  }
}
