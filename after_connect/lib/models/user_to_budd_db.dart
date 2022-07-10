import 'dart:math';

import 'package:after_connect_v2/db/budd_db.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';

class UserToBuddDb{
  final _db = FirebaseFirestore.instance;

  ///ユーザIDと仏壇IDをセットにしてDBに格納する
  void connectId(int userId, String buddId)async{
    await _db.collection("user_to_budd").add({
      "buddId":buddId,
      "userId":userId,
      "timestamp":Timestamp.fromDate(DateTime.now()),
      "isUsed":false,
    });
  }

  Future<List<String>> getBuddIdList(int userId)async{
    List<String> _buddId = <String>[];
    /// ユーザIDが登録されているドキュメントを持ってくる
    QuerySnapshot querySnapshot = await _db.collection("user_to_budd").where("userId",isEqualTo: userId).where("isUsed",isEqualTo: true)/*.orderBy("timestamp", descending: true)*/.get();
    DocumentSnapshot? docSnapshot;
    for(var doc in querySnapshot.docs) {
      docSnapshot = await doc.reference.get();
      if(docSnapshot.exists) _buddId.add(docSnapshot["buddId"]); /// 仏壇IDを取得
    }
    return _buddId;
  }

}