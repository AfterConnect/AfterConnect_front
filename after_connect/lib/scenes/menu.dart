import 'package:after_connect_v2/scenes/user_conf_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';
import 'top.dart';
import '../util/authentication.dart';
import '../models/budd_list_model.dart';

class Menu extends StatelessWidget {
  static const routeName = '/menu';
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('MENU',style: TextStyle(color: Colors.black)),

      ),

      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 50.0,
            ),
            child: Column(
              children: [

                ///仏壇画面へ
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    //ルーティングで画面遷移管理
                    //BuddListModel.DataCheck = true;
                    Get.toNamed(Home.routeName + '/1');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      '仏壇画面へ',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10.0,
                ),

                ///スライドショー
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    //ルーティングで画面遷移管理
                    //Get.toNamed(HogeHoge.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      'スライドショー',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10.0,
                ),

                ///スケジュール通知
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    //ルーティングで画面遷移管理
                    //Get.toNamed(HogeHoge.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      'スケジュール通知',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10.0,
                ),

                ///仏壇共有コード入力
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    //ルーティングで画面遷移管理
                    //Get.toNamed(HogeHoge.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      '共有コードの入力',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10.0,
                ),

                ///設定
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    //ルーティングで画面遷移管理
                    Get.toNamed(UserConfPage.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      '設定',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10.0,
                ),

                ///ログアウト
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    //ルーティングで画面遷移管理
                    //Get.toNamed(HogeHoge.routeName);

                    Get.defaultDialog(
                      title: 'ログアウトしますか？',
                      middleText: 'この操作は取り消せません',
                      onConfirm: (){
                        BuddListModel.DataCheck = false;
                        BuddListModel.BuddListNum = null;
                        Authentication.signOut(context: context);
                        Get.offAllNamed(Top.routeName);
                        debugPrint('ログアウトします');
                      },
                      textConfirm: 'ログアウト',
                      textCancel: '戻る',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      'ログアウト',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
