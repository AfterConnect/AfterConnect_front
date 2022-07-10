import 'package:after_connect_v2/models/user_to_budd_db.dart';
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
  static List<Budd> BuddList = <Budd>[];
  static int? BuddListNum;
  HomeModel? _homeModel;
  DocumentSnapshot? docSnapshot;
  QuerySnapshot? querySnapshot;
  final _db = FirebaseFirestore.instance;
  static int userId = 0;
  List<String> _buddIdList = <String>[];


  BuddListModel(){
    debugPrint('再読み込みするか否か→$DataCheck');
    checkUserId().then((value) {
      if(value){
        UsersDb().getUserId(user!.email!).then((uId){
          debugPrint("ユーザIDだよ→$uId");
          UserToBuddDb().getBuddIdList(uId).then((bId){
            BuddIdList = bId;
            if(BuddIdList != null){
              BuddListNum = BuddIdList!.length;
              debugPrint("仏壇IDだよ→$bId");
            }
          });
        });
      }
    });
  }

  ///ユーザIDが存在するかを確認
  ///なければユーザIDとユーザメールアドレスを登録
  Future<bool> checkUserId()async{

    ///emailにユーザメールアドレスが登録されているドキュメントを取得
    querySnapshot = await _db.collection('users').where('email', isEqualTo: user!.email).where('isUsed', isEqualTo: true).get();

    ///1つしか無いはずだが、仕様上Listで得られるのでfor文で一個ずつ中身(ドキュメント)を取得
    for (var element in querySnapshot!.docs) {
      docSnapshot = element;
    }

    if(docSnapshot != null && docSnapshot!.exists){
      ///存在した(登録済み)場合の処理
      debugPrint('ユーザIDが登録されていました！');

      return true;
    }else{
      ///存在しない(未登録の)場合の処理
      debugPrint('ユーザIDが登録されていません・・・');

      ///ユーザIDとユーザメルアドを紐づける処理
      ///返り値は割り当てられたユーザID
      UsersDb().makeUserDb().then((value){
        ///ここ超大事
        ///makeBudd()で余分なuserIdを消す際、値の小さいのを消している
        ///なのでそれに合わせたif文を挟んでいる
        if(userId < value) userId = value;
      });

      /// 仏壇を2つ作る
      /// それぞれの仏壇IDが引数
      /// (何故か4つの仏壇が完成する)
      for (int i = 0; i < 2; i++) {
        debugPrint('$i回目の仏壇作成！');
        BuddDb().makeBudd().then((value){
          _buddIdList.add(value);
        });
        await Future<void>.delayed(const Duration(milliseconds: 1000));
      }

      /// 作った仏壇のすべての仏壇IDを中間テーブルとしてユーザIDと紐づける
      for(String str in _buddIdList) {
        debugPrint("新規作成した仏壇IDは：$str");
        UserToBuddDb().connectId(userId, str);
      }

      /// 中間テーブル(user_to_budd)からユーザIDと紐づいている、
      /// かつ先程作ったばかりの未使用(isUsed = false)のものを2つ抽出
      QuerySnapshot userSnapshot = await _db.collection("user_to_budd").where("userId",isEqualTo: userId).where("isUsed",isEqualTo: false).limit(2).get();
      for(var doc in userSnapshot.docs) {
        doc.reference.update(
            {"isUsed": true}  ///使用中(isUsed = ture)にする
        );
      }

      ///もう一度中間テーブルからユーザIDと紐づいている、かつ未使用のものを 全て 抽出
      userSnapshot = await _db.collection("user_to_budd").where("userId",isEqualTo: userId).where("isUsed",isEqualTo: false).get();
      for(var doc in userSnapshot.docs) {
        doc.reference.delete(); ///消し去る → これで望み通り仏壇が2つだけになる(4つ作っちゃってた)
      }

      return true;
    }
  }

  void fetchBuddList()async{
    debugPrint('fetchBuddListに入ったよ！');
    while (BuddListNum == null) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    if(!DataCheck) {

      if (BuddListNum != null) debugPrint('BuddListModel()終わったよ！');
      for(int i = 1; i <= BuddListNum!; i++){
        debugPrint('$i番目のfor文です！');
        _homeModel = HomeModel(i);
        while(_homeModel == null){
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }

        _homeModel!.setBuddId(BuddIdList!.elementAt(i-1));
        while(_homeModel!.getBuddId() == null){
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }

        _homeModel!.fetchBuddInfo();
        while(_homeModel!.getBudd() == null){
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
        debugPrint('${_homeModel!.getBudd()!}');
        BuddList.add(_homeModel!.getBudd()!);
      }
      while (BuddList.length < BuddListNum!) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      debugPrint('0番目の名前は：${BuddList.elementAt(0).buddName}');
      DataCheck = true;

    }
    notifyListeners();
  }

}