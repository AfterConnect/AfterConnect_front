import 'package:after_connect_v2/main.dart';
import 'package:after_connect_v2/models/budd_list_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'users_db.dart';


class BuddDb{
  /// length桁のランダムIDを生成する
  /// IDには数字、大文字小文字アルファベットが含まれる
  String randomID(int length) {
    const _randomChars = "ABCDEFGHIJKLMNPQRSTUVWXYZabcdefghijklmnpqrstuvwxyz123456789";
    const _charsLength = _randomChars.length;

    final rand = new Random.secure();
    final codeUnits = new List.generate(
      length,
          (index) {
        final n = rand.nextInt(_charsLength);
        return _randomChars.codeUnitAt(n);
      },
    );
    return new String.fromCharCodes(codeUnits);
  }



  ///仏壇の初期設定(旧式)
  void makeBudd_mistake() async{
    String buddId = randomID(10);
    DocumentReference docRef = FirebaseFirestore.instance.doc(
        'budds/$buddId');
    DocumentSnapshot docSnapshot = await docRef.get();

    while (docSnapshot.exists) {
      debugPrint('失敗した仏壇ID：$buddId');
      debugPrint('仏壇IDを再設定');
      buddId = randomID(10);
      docRef = FirebaseFirestore.instance.doc('budds/$buddId');
      docSnapshot = await docRef.get();
    }

    await docRef.set({
      'userIds':[],
      'isUsed': false,
      'buddName': '故人のお名前',
      'buddPhoto': 'http://firebasestorage.googleapis.com/v0/b/after-connect.appspot.com/o/default%2Fbudd%2Fbudd_photo.png?alt=media&token=f52e5376-fc1d-40f9-b467-710609280149',
    });

    //docRef = FirebaseFirestore.instance.doc('budds/$buddId/items');
    await FirebaseFirestore.instance.doc('budds/$buddId/itemsList/items').set({
      'kou': false,
      'hana': false,
      'toumyou': false,
      'mizu': false,
      'kome': false,
    });
    UsersDb().setBuddId(buddId);
  }


  void makeBudd() async{
    final _db = FirebaseFirestore.instance;
    String buddId = randomID(10);
    DocumentReference docRef = _db.doc('budds/$buddId');
    DocumentSnapshot docSnapshot = await docRef.get();

    while (docSnapshot.exists) {
      debugPrint('失敗した仏壇ID：$buddId');
      debugPrint('仏壇IDを再設定');
      buddId = randomID(10);
      docRef = _db.doc('budds/$buddId');
      docSnapshot = await docRef.get();
    }

    int _userId = 0;
    int _maxUserId = 0;
    /*await _db.collection('users').where('email', isEqualTo: user!.email).get().then(
            (snapshot) => {
              snapshot.docs.forEach((element) {
                if(element.get('isUsed') == true){
                  debugPrint("true見つけた！：" + element.reference.id);
                  _userId = int.parse(element.reference.id);
                }else {
                  debugPrint("ユーザIDです！：" + element.reference.id);
                  if(_maxUserId < int.parse(element.reference.id)){
                    _maxUserId = int.parse(element.reference.id);
                  }else{
                    _db.collection('users').doc(element.reference.id).delete();
                  }
                }
              }
              )
            }
    );*/

    /*if(_userId == 0){
      _userId = _maxUserId;
      debugPrint('_userId : $_userId');
      _db.collection('users').doc('$_userId').update(
        {'isUsed':true}
      );
    }*/

    /*await _db.collection('users').where('email', isEqualTo: user!.email).get().then(
            (snapshot) => {
          snapshot.docs.forEach((element) {
            if(element.get('isUsed') == false){
              _db.collection('users').doc(element.reference.id).delete();
            }
          })
        }
    );*/

    await docRef.set({
      'userIds':[user!.email],
      'isUsed': false,
      'buddName': '故人のお名前',
      'buddPhoto': 'http://firebasestorage.googleapis.com/v0/b/after-connect.appspot.com/o/default%2Fbudd%2Fbudd_photo.png?alt=media&token=f52e5376-fc1d-40f9-b467-710609280149',
      'items':{
        'kou': false,
        'hana': false,
        'toumyou': false,
        'mizu': false,
        'kome': false,
      },
    });

  }


  ///故人の写真を変更する
  void setBuddPhoto(String buddId, String newBuddPhoto)async{
    DocumentReference docRef = FirebaseFirestore.instance.doc('budds/$buddId');
    DocumentSnapshot docSnapshot = await docRef.get();

    if(docSnapshot.exists){
      await docRef.set(
        {
        'buddPhoto': newBuddPhoto,
        },
        SetOptions(merge: true),
      );
      BuddListModel.DataCheck = false;
    }
  }

  ///故人の名前を変更する
  void setBuddName(String buddId, String newBuddName)async{
    DocumentReference docRef = FirebaseFirestore.instance.doc('budds/$buddId');
    DocumentSnapshot docSnapshot = await docRef.get();

    if(docSnapshot.exists){
      await docRef.set(
        {
          'buddName': newBuddName,
        },
        SetOptions(merge: true),
      );
      BuddListModel.DataCheck = false;
    }
  }

  Future<String?> getBuddName(String? buddId) async{
    DocumentReference docRef = FirebaseFirestore.instance.doc('budds/$buddId');
    DocumentSnapshot docSnapshot = await docRef.get();
    if(docSnapshot.exists){
      return docSnapshot['buddName'];
    }
  }

  Future<String?> getBuddPhoto(String? buddId) async{
    DocumentReference docRef = FirebaseFirestore.instance.doc('budds/$buddId');
    DocumentSnapshot docSnapshot = await docRef.get();

    if(docSnapshot.exists){
      return docSnapshot['buddPhoto'];
    }
  }

  Future<bool?> checkIsUsed(String? buddId) async{
    DocumentReference docRef = FirebaseFirestore.instance.doc('budds/$buddId');
    DocumentSnapshot docSnapshot = await docRef.get();
    if(docSnapshot.exists){
      return docSnapshot['isUsed'];
    }
  }


}