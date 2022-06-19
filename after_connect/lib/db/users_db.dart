import 'dart:math';

import 'package:after_connect_v2/db/budd_db.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';

class UsersDb {


  ///引数で与えられた桁数のランダムな整数を返す
  int randomID(int length) {

    var rand = new Random();
    var next = rand.nextDouble();
    var check = 1;
    for(int i = 0; i < length-1; i++) {
      check *= 10;
    }
    next *= check;

    while (next < check) {
      next *= 10;
    }

    return next.toInt();
  }

  ///ユーザデータベースを構築
  ///usersコレクションに登録する
  void makeUserDb() async{
    ///10桁のランダム整数を生成
    int _userId = randomID(10);
    final _db = FirebaseFirestore.instance;

    DocumentReference docRef = _db.doc('users/$_userId');
    DocumentSnapshot docSnapshot = await docRef.get();
    while (docSnapshot.exists) { ///ユーザIDに被りが無いようにする
      debugPrint('失敗した仏壇ID：$_userId');
      debugPrint('仏壇IDを再設定');
      _userId = randomID(10);
      docRef = _db.doc('users/$_userId');
      docSnapshot = await docRef.get();
    }

    await docRef.set({
      'email': user!.email,
      'isUsed':false,
    });

  }


  void setBuddId(String buddId) async{
    int _num = 0;
    List? _buddList;
    bool setCheck = true;
    DocumentReference docRef = FirebaseFirestore.instance.doc('users/${user!.email}');
    DocumentSnapshot docSnapshot = await docRef.get();

    await UsersDb().getBuddsList('${user!.email}').then((value) => _buddList = value);
    for(int i = 0; i < _buddList!.length; i++){
      if('${_buddList!.elementAt(i)}' == buddId){
        setCheck = false;
      }
    }
    if(setCheck) {
      if(docSnapshot.exists){
        _num = docSnapshot['buddsNum'] + 1;
        await docRef.update(
          {'buddsNum': _num},
        );
      }else {
        await docRef.set(
          {
            'buddsNum': _num,
          },
          SetOptions(merge: true),
        );
      }
      await docRef
          .collection('buddsList')
          .doc('buddIds')
          .set(
        {
          '$_num': buddId,
        },
        SetOptions(merge: true),
      );
    }
  }


  ///ユーザーが保有している仏壇IDのゲッター
  ///仏壇Idのリストが返される
  Future<List?> getBuddsList(String? userId)async{
    List IDlist = <String>[];
    int listNum = 0;

    DocumentReference docRef = FirebaseFirestore.instance.doc('users/$userId');
    DocumentSnapshot docSnapshot = await docRef.get();
    DocumentSnapshot IDSnapshot = await FirebaseFirestore.instance.doc('users/$userId/buddsList/buddIds').get();

    if(docSnapshot.exists){
      listNum = docSnapshot['buddsNum'];
      for(int i = 0; i <= listNum; i++){
        IDlist.add(IDSnapshot['$i']);
        //debugPrint('${IDSnapshot['$i']} をIDリストに入れたよ');
      }
    }
    IDlist.forEach((element) {debugPrint(element); });
    return IDlist;
  }

  ///仏壇Idを返す
  Future<String?> getBuddId(String? userId,int? IdNum)async{
    debugPrint('ユーザID：$userId,IdNum：$IdNum');
    List? buddIdsList;
    getBuddsList(userId).then((value) {
      buddIdsList = value;
      if(buddIdsList != null && IdNum != null) {
        debugPrint('getBuddIdで返す値だよ：${buddIdsList!.elementAt(IdNum)}');
        return buddIdsList!.elementAt(IdNum);
      }
    });
  }




}
