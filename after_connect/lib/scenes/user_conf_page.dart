import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import 'user_name_change_page.dart';
import '../util/authentication.dart';
import 'top.dart';

class UserConfPage extends StatelessWidget {
  static const routeName = '/conf';
  const UserConfPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('設定',style: TextStyle(color: Colors.black)),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
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

                ///ユーザー名変更
                ///開発者用設定項目
                /*OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    //ルーティングで画面遷移管理
                    Get.toNamed(routeName + UserNameChangePage.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      'ユーザー名変更',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10.0,
                ),*/


                ///パスワード変更
                Visibility(
                  visible: (user!.providerData[0].providerId == 'password'),
                  child:
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 1.0, color: Colors.black),
                      // primary: Colors.white,
                      minimumSize: const Size.fromHeight(10),
                    ),
                    onPressed: () async{
                      if(await Authentication.recoverPasswordOfMail(user!.email!) == true){
                        await Get.defaultDialog(
                          title: 'パスワード再設定用メールを送信しました',
                          middleText: 'ログインアドレス(${user!.email!})に再設定用リンクを送信しました',
                          textCancel: '閉じる',
                        );
                      }else{
                        await Get.defaultDialog(
                          title: 'パスワードの再設定時にエラーが発生しました',
                          middleText: '一度ログアウトして再度ログインしてください',
                          onConfirm: (){
                            Authentication.signOut(context: context);
                            Get.offAllNamed(Top.routeName);
                            debugPrint('ログアウトします');
                          },
                          textConfirm: 'ログアウト',
                          textCancel: '閉じる',
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      child:Text(
                        'パスワード変更',
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (user!.providerData[0].providerId == 'password'),
                  child: const SizedBox(
                    height: 10.0,
                  ),
                ),

                ///ほげほげ
                /*OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    //ルーティングで画面遷移管理
                    //Get.toNamed(Home.routeName + '/1');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      'ほげほげ',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),*/

              ],
            ),
          ),
        ],
      ),
    );
  }
}
