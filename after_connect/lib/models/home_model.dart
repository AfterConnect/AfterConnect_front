import 'package:after_connect_v2/domain/budd.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../db/users_db.dart';
import '../db/budd_db.dart';
import '../main.dart';
import 'budd_list_model.dart';

class HomeModel {
  String? _buddsNum;
  Stream<QuerySnapshot>? _usersStream;
  Stream<DocumentSnapshot>? _buddsStream;
  String? buddId;
  Budd? budd;


  HomeModel(int homeId){
    _buddsNum = (homeId - 1).toString();
    _usersStream =
        FirebaseFirestore.instance.collection('users/${user!.email}/buddsList').snapshots();
    //fetchBuddId(_buddsNum!);
  }

  String? getBuddId(){
    return buddId;
  }
  Budd? getBudd(){
    return budd;
  }
  Stream<QuerySnapshot>? getUserStream(){

  }

  void fetchBuddId(String buddNum)async{
    debugPrint('fetchBuddIdに入ったよ！');
    if(_usersStream != null) {
      _usersStream!.listen((QuerySnapshot snapshot) {
        final String _buddId = snapshot.docs.map((DocumentSnapshot document){
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          final String buddId = data[buddNum];
          this.buddId = buddId;
          return buddId;
        }).toString();
        debugPrint('テスト：buddIdの値→$buddId');

      });
    }
    //notifyListeners();
  }


  void fetchBuddInfo(){
    _buddsStream =
        FirebaseFirestore.instance.collection('budds').doc(buddId).snapshots();

    if(_buddsStream != null){
      _buddsStream!.listen((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final String buddId = document.id;
        final String buddName = data['buddName'];
        final String buddPhoto = data['buddPhoto'];
        debugPrint('テスト：buddNameの値→$buddName');
        debugPrint('テスト：buddPhotoの値→$buddPhoto');
        budd = Budd(buddId, buddName, buddPhoto);
        BuddListModel.DataCheck = false;
        //notifyListeners();
      });
    }
  }




  /*String? buddId = "テスト";
  String buddName = "";
  String? buddPhoto;
  List? buddsList;

  HomeModel(int buddNum){
    //buddId = UsersDb().getBuddId(user!.email, buddNum - 1);

    /*UsersDb().getBuddId(user!.email, buddNum - 1).then((value){
      if(value != null) buddId = value;
    });
    Timer(const Duration(milliseconds: 10),nullmethod);
    //await Future<void>.delayed(Duration(seconds: 1));
    debugPrint('ユーザId：${user!.email}');
    debugPrint('buddIdに入れたい値：${UsersDb().getBuddId(user!.email, buddNum - 1)}');
    debugPrint('buddIdの中身：$buddId');*/

    setValue(buddNum);

  }

  Future<void> setValue(int buddNum) async{
    /*await UsersDb().getBuddId(user!.email, buddNum - 1).then((value){
      if(value != null) buddId = value;
    });*/

    buddId = await UsersDb().getBuddId(user!.email, buddNum - 1);

    Timer(const Duration(milliseconds: 10),nullmethod);
    //await Future<void>.delayed(Duration(seconds: 1));
    debugPrint('ユーザId：${user!.email}');
    debugPrint('buddIdに入れたい値：${UsersDb().getBuddId(user!.email, buddNum - 1)}');
    debugPrint('buddIdの中身：$buddId');
  }





  void nullmethod(){
    debugPrint("止まったはず");
    BuddDb().getBuddName(buddId).then((value) {
      if(value != null) {
        buddName = value;
      }
    });
    BuddDb().getBuddPhoto(buddId).then((value) => buddPhoto = value);
    debugPrint('buddIdの中身：$buddId');
  }*/




}