import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentCount extends StatelessWidget {
  final String collectionName;
  final String timestamp;
  const CommentCount({super.key, required this.collectionName, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return
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
            snap.data['comments count'].toString(),
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey),
          );
        },
      );

  }
}