import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../db/users_db.dart';
import '../db/budd_db.dart';
import '../main.dart';

class HomeModel extends ChangeNotifier{
  String? buddId;
  String buddName = "";
  String? buddPhoto;
  List? buddsList;

  HomeModel(int buddNum){
    buddId = UsersDb().getBuddId(user!.email, buddNum - 1);
    debugPrint('ユーザId：${user!.email}');
    debugPrint('buddIdに入れたい値：${UsersDb().getBuddId(user!.email, buddNum - 1)}');
    debugPrint('buddIdの中身：$buddId');
    BuddDb().getBuddName(buddId).then((value) {
      if(value != null) {
        buddName = value;
      }
    });
    BuddDb().getBuddPhoto(buddId).then((value) => buddPhoto = value);

    //setHomeModel(buddNum);



  }

  Future<void> setHomeModel(int buddNum)async{
    buddId = UsersDb().getBuddId(user!.email, buddNum - 1);
    /*while(buddId == null){
      debugPrint('buddIdに入れたい値：$buddId');
    }*/
    debugPrint('ユーザId：${user!.email}');
    debugPrint('buddIdの中身：$buddId');
    await BuddDb().getBuddName(buddId).then((value) {
      if(value != null){
        buddName = value;
      }
    });
    await BuddDb().getBuddPhoto(buddId).then((value) => buddPhoto = value);
  }



}