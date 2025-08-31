import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CommentsBloc extends ChangeNotifier{


  late String date;
  late String timestamp1;



  Future saveNewComment(String collectionName, String timestamp, String newComment) async{

    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? name = sp.getString('name');
    String? uid = sp.getString('uid');
    String? imageUrl = sp.getString('image_url');

    await _getDate()
        .then((value) => FirebaseFirestore.instance
        .collection('$collectionName/$timestamp/comments')
        .doc('$uid$timestamp1').set({
      'name': name,
      'comment' : newComment,
      'date' : date,
      'image url' : imageUrl,
      'timestamp': timestamp1,
      'uid' : uid
    })).then((value){
      if(collectionName == 'places'){
        commentInrement(collectionName, timestamp);
      }
    });


    notifyListeners();

  }





  Future deleteComment (String collectionName, timestamp, uid, timestamp2, ) async{

    await FirebaseFirestore.instance.collection('$collectionName/$timestamp/comments').doc('$uid$timestamp2').delete()
        .then((value){
      if(collectionName == 'places'){
        commentDecrement(collectionName, timestamp);
      }
    });
    notifyListeners();
  }




  Future commentInrement (String collectionName, String timestamp) async {

    final DocumentReference ref = FirebaseFirestore.instance.collection(collectionName).doc(timestamp);
    DocumentSnapshot snap = await ref.get();
    int commentsAmount = snap['comments count'];
    await ref.update({
      'comments count' : commentsAmount + 1
    });
  }


  Future commentDecrement (String collectionName, String timestamp) async {

    final DocumentReference ref = FirebaseFirestore.instance.collection(collectionName).doc(timestamp);
    DocumentSnapshot snap = await ref.get();
    int commentsAmount = snap['comments count'];
    await ref.update({
      'comments count' : commentsAmount - 1
    });
  }





  Future _getDate() async {
    DateTime now = DateTime.now();
    String dateStr = DateFormat('dd MMMM yy').format(now);
    String tsStr = DateFormat('yyyyMMddHHmmss').format(now);
    date = dateStr;
    timestamp1 = tsStr;
  }


}