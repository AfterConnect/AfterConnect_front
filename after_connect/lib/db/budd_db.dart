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

  ///仏壇の初期設定
  void makeBudd() async{
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
      'buddName': '故人のお名前',
      'buddPhoto': 'https://firebasestorage.googleapis.com/v0/b/after-connect.appspot.com/o/default%2Fbudd%2Fbudd_photo.png?alt=media&token=f52e5376-fc1d-40f9-b467-710609280149',
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


}