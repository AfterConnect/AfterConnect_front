import 'dart:async';
import 'dart:core';

import 'package:after_connect_v2/main.dart';
import 'package:after_connect_v2/scenes/add_home_dialog_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../db/budd_db.dart';
import '../domain/budd.dart';
import '../models/budd_list_model.dart';
import '../db/user_to_budd_db.dart';
import 'modal_overlay.dart';
import 'home.dart';

class MakeHomeDialogPage {

  BuildContext context;
  MakeHomeDialogPage(this.context) : super();
  List<Budd>? budd;
  int? userId;
  bool _reload = false;

  void setBudd(List<Budd> budd){
    this.budd = budd;
  }
  int? getUserId(){
    return userId;
  }
  void setUserId(int userId){
    this.userId = userId;
  }

  /*
   * 表示
   */
  void showCustomDialog() {

    Navigator.push(
      context,
      ModalOverlay(
        Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Stack(

                  children: <Widget>[

                    SizedBox(
                        height: 200.0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[

                                /*
                               * タイトル
                               */
                                Text(
                                  " 仏壇の追加方法 ",
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    locale: Locale("ja", "JP"),
                                  ),
                                ),

                                /*
                               * メッセージ
                               */
                                Text(
                                  "  新規作成：新しく仏壇を作成  ",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    locale: Locale("ja", "JP"),
                                  ),
                                ),
                                Text(
                                  "  →今はワンクリックで無条件に作れちゃうので気を付けて！  ",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    locale: Locale("ja", "JP"),
                                  ),
                                ),
                                Text(
                                  "  追加：共有コードを使用して仏壇を追加  ",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    locale: Locale("ja", "JP"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                ),

                /*
               * OKボタン
               */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white
                      ),
                      child: const Text(
                        "新規作成",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          locale: Locale("ja", "JP"),
                        ),
                      ),
                      onPressed: () async{
                        final _db = FirebaseFirestore.instance;
                        String? buddId;

                        /// 仏壇を作る
                        BuddDb().makeBudd().then((value) {
                          buddId = value;
                        });
                        while(buddId == null){
                          await Future<void>.delayed(const Duration(milliseconds: 10));
                        }

                        while(userId == null || userId == 0){
                          await Future<void>.delayed(const Duration(milliseconds: 10));
                        }
                        /// 作った仏壇の仏壇IDを中間テーブルとしてユーザIDと紐づける
                        UserToBuddDb().connectId(userId!, buddId!);
                        await Future<void>.delayed(const Duration(milliseconds: 1000));

                        /// 中間テーブル(user_to_budd)からユーザIDと紐づいている、
                        /// かつ先程作ったばかりの未使用(isUsed = false)のものを1つ抽出
                        QuerySnapshot userSnapshot = await _db.collection("user_to_budd").where("userId",isEqualTo: userId!).where("buddId",isEqualTo: buddId).where("isUsed",isEqualTo: false).limit(1).get();
                        for(var doc in userSnapshot.docs) {
                          doc.reference.update(
                              {"isUsed": true}  ///使用中(isUsed = ture)にする
                          );
                        }

                        ///もう一度中間テーブルからユーザIDと紐づいている、かつ未使用のものを 全て 抽出
                        userSnapshot = await _db.collection("user_to_budd").where("userId",isEqualTo: userId!).where("isUsed",isEqualTo: false).get();
                        if(userSnapshot.docs.isNotEmpty) {
                          for (var doc in userSnapshot.docs) {
                            doc.reference.delete(); ///消し去る
                          }
                        }

                        await Future<void>.delayed(const Duration(milliseconds: 1500));
                        BuddListModel.DataCheck = false;
                        _reload = true;
                        hideCustomDialog();

                      },
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white
                      ),
                      child: const Text(
                        "追加",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          locale: Locale("ja", "JP"),
                        ),
                      ),
                      onPressed: () async{
                        AddHomeDialogPage addHome = AddHomeDialogPage(context);
                        hideCustomDialog();
                        addHome.setBudd(budd!);
                        while(userId == null){
                          await Future<void>.delayed(const Duration(milliseconds: 10));
                        }
                        addHome.setUserId(userId!);
                        while(addHome.getUserId() == null && addHome.getUserId() == 0){
                          await Future<void>.delayed(const Duration(milliseconds: 10));
                        }
                        addHome.showCustomDialog();
                      },
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),

                    ElevatedButton(
                      child: const Text(
                        "閉じる",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          locale: Locale("ja", "JP"),
                        ),
                      ),
                      onPressed: () {
                        hideCustomDialog();
                      },
                    ),
                  ],
                ),
              ],
            )
        ),
        isAndroidBackEnable: false,
      ),
    );
  }


  /*
   * 非表示
   */
  void hideCustomDialog() {
    if(_reload){
      Get.offAllNamed('${Home.routeName}/${BuddListModel.BuddListNum!+1}');
    }else{
      Navigator.of(context).pop();
    }
  }
}