import 'package:after_connect_v2/db/budd_db.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';

class UsersDb {

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
    }/*else if(user != null){
      for(int i = 0; i < 2 ; i++){
        debugPrint('$i回目の仏壇作成！');
        //BuddDb().makeBudd();
        await Future<void>.delayed(const Duration(milliseconds: 3000));
      }
      await Future<void>.delayed(const Duration(milliseconds: 30000));
      return getBuddsList(userId);
    }*/
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
