import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LoveCount extends StatelessWidget {
  final String collectionName;
  final String timestamp;
  const LoveCount({super.key, required this.collectionName, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.favorite,
          color: Colors.grey[500],
          size: 18,
        ),
        const SizedBox(
          width: 2,
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName)
              .doc(timestamp)
              .snapshots(),
          builder: (context, AsyncSnapshot snap) {
            if (!snap.hasData) {
              return const Text(
                '0',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              );
            }
            return Text(
              snap.data['loves'].toString(),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            );
          },
        ),
        const SizedBox(
          width: 5,
        ),
        // ignore: prefer_const_constructors
        Text(
          'people like this',
          maxLines: 1,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
        ).tr(),
        
      ],
    );
  }
}
