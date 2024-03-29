import 'package:after_connect_v2/domain/budd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'budd_list_model.dart';

class HomeModel {
  String? _buddsNum;
  Stream<QuerySnapshot>? _usersStream;
  Stream<DocumentSnapshot>? _buddsStream;
  String? buddId;
  Budd? budd;
  final _db = FirebaseFirestore.instance;


  HomeModel(int homeId){
    _buddsNum = (homeId - 1).toString();
  }

  String? getBuddId(){
    return buddId;
  }
  Budd? getBudd(){
    return budd;
  }
  void setBuddId(String bId){
    buddId = bId;
  }
  void setBudd(Budd _budd){
    budd = _budd;
  }
  Stream<QuerySnapshot>? getUserStream(){

  }

  void fetchBuddId(String buddNum)async{
    debugPrint('fetchBuddIdに入ったよ！');
    if(_usersStream != null) {
      _usersStream!.listen((QuerySnapshot snapshot) {
        final String _buddId = snapshot.docs.map((DocumentSnapshot document){
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          _buddsStream = snapshot.docChanges as Stream<DocumentSnapshot<Object?>>?;
          final String buddId = data[buddNum];
          this.buddId = buddId;
          buddIsUsed(buddId);
          return buddId;
        }).toString();
        debugPrint('テスト：buddIdの値→$buddId');

      });
    }

    
  }


  void fetchBuddInfo(){
    _buddsStream =
        FirebaseFirestore.instance.collection('budds').doc(buddId).snapshots();

    if(_buddsStream != null){
      buddIsUsed(buddId!);
      _buddsStream!.listen((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final String buddId = document.id;
        final String buddName = data['buddName'];
        final String buddPhoto = data['buddPhoto'];
        final Map<String,DateTime> buddItems = () {
          Map<String, DateTime> map = {};
          Map<String, Timestamp>.from(data['items']).forEach((key, value) {
            map[key] = value.toDate();
          });
          return map;
        }();
          debugPrint('テスト：buddNameの値→$buddName');
          debugPrint('テスト：buddPhotoの値→$buddPhoto');
          budd = Budd(buddId, buddName, buddPhoto,buddItems);
          BuddListModel.DataCheck = false;
      });
    }
  }

  void buddIsUsed(String buddId)async{
    final docRef = _db.doc('budds/$buddId');
    await docRef.set({
      'isUsed': true,
    },
      SetOptions(merge: true),
    );
  }


}