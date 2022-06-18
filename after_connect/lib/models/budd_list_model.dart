import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../db/budd_db.dart';
import '../main.dart';
import 'home_model.dart';
import '../domain/budd.dart';
import '../db/users_db.dart';

class BuddListModel extends ChangeNotifier {
  ///true = データ取得済み
  ///false = データ未取得
  static bool DataCheck = false;
  Stream<QuerySnapshot>? _usersStream;
  Stream<DocumentSnapshot>? _buddsStream;
  List<String>? BuddIdList;
  static List<Budd>? BuddList = <Budd>[];
  static int? BuddListNum;
  HomeModel? _homeModel;
  DocumentSnapshot? docSnapshot;
  QuerySnapshot? querySnapshot;


  BuddListModel(){
    debugPrint('再読み込みするか否か→$DataCheck');
    checkBuddMade().then((value) {
      if(value){
        UsersDb().getBuddsList(user!.email).then((value){
          BuddIdList = value as List<String>;
          if(BuddIdList != null) BuddListNum = BuddIdList!.length;
        });
      }
    });
  }

  ///仏壇データが存在するかを確認
  ///なければ(ユーザー登録直後なら)2つ仏壇を作る
  Future<bool> checkBuddMade()async{
    querySnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: '${user!.email}').get();
    docSnapshot = querySnapshot!.docs as DocumentSnapshot<Object?>?;
    if(docSnapshot!.exists){
      return true;
    }else{
      for(int i = 0; i < 2 ; i++){
        debugPrint('$i回目の仏壇作成！');
        BuddDb().makeBudd();
        await Future<void>.delayed(const Duration(milliseconds: 1000));
      }
      return true;
    }
  }

  void fetchBuddList()async{
    if(!DataCheck) {
      BuddListModel();
      while (BuddListNum == null) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }

      if (BuddListNum != null) debugPrint('BuddListModel()終わったよ！');
      fetchBuddIdList();
      while (BuddList!.length < BuddListNum!) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      debugPrint('0番目の名前は：${BuddList!.elementAt(0).buddName}');
      DataCheck = true;
    }
    notifyListeners();

  }


  void fetchBuddIdList()async {
    BuddList = <Budd>[];
    for(int i = 1; i <= BuddListNum!; i++){
      debugPrint('$i番目のfor文です！');
      _homeModel = HomeModel(i);
      while(_homeModel == null){
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      _homeModel!.fetchBuddId((i-1).toString());
      while(_homeModel!.getBuddId() == null){
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      _homeModel!.fetchBuddInfo();
      while(_homeModel!.getBudd() == null){
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      debugPrint('${_homeModel!.getBudd()!}');
      BuddList!.add(_homeModel!.getBudd()!);
    }
  }
}