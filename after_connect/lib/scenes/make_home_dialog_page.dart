import 'package:after_connect_v2/scenes/add_home_dialog_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../db/budd_db.dart';
import '../domain/budd.dart';
import '../models/budd_list_model.dart';
import 'modal_overlay.dart';
import 'home.dart';

class MakeHomeDialogPage {

  BuildContext context;
  MakeHomeDialogPage(this.context) : super();
  List<Budd>? budd;

  void setBudd(List<Budd> budd){
    this.budd = budd;
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
                        BuddDb().makeBudd();
                        await Future<void>.delayed(const Duration(milliseconds: 1500));
                        BuddListModel.DataCheck = false;
                        hideCustomDialog();
                        Get.offAllNamed('${Home.routeName}/${BuddListModel.BuddListNum!+1}');
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
                      onPressed: () {
                        AddHomeDialogPage addHome = AddHomeDialogPage(context);
                        hideCustomDialog();
                        addHome.setBudd(budd!);
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

    Navigator.of(context).pop();
  }
}