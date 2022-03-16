import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import 'top.dart';
import 'menu.dart';


class Home extends StatefulWidget {
  static const routeName = '/home';

  const Home({Key? key/*, required this.homeNumber*/}) : super(key: key);

  //final String homeNumber;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //いくつ目の仏壇のかを表す変数
  //初期値は１
  final _homeNum = int.parse(Get.parameters['homeNum']!);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            debugPrint('Homeにてメニューボタンが押されました');
            Get.toNamed(Menu.routeName);
          },
          icon: const Icon(Icons.menu),
        ),

        actions: [
          IconButton(
            onPressed: () {
              debugPrint('Homeにて共有ボタンが押されました');
              Get.toNamed(Top.routeName);
            },
            icon: const Icon(Icons.ios_share),
          ),
        ],

        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),

        title:Text(
          '仏壇No.$_homeNum',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),

      ),

      body:Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '仏様のお名前(仮)',
                  style: TextStyle(
                      fontSize: 40.0
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child:Image.network('https://4.bp.blogspot.com/-vpajUL6jZkw/VMIu9i4l5aI/AAAAAAAAq2M/TPYfH7t6kXQ/s800/butsudan.png'),
          ),
          Flexible(
            flex: 1,
            child: Column(
              children: [
                ((){
                  if (userGoogle != null) {

                    debugPrint(userGoogle?.displayName);
                    return Text(
                      'ログインユーザー名：${userGoogle?.displayName}',
                      style: const TextStyle(
                          fontSize: 20.0
                      ),
                    );
                  }else {
                    return const Text(
                      'Googleアカウントでログインしていません',
                      style: TextStyle(
                          fontSize: 20.0
                      ),
                    );
                  }
                })(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 50.0,
            ),
            child: Column(
              children: [

                OutlinedButton(
                  style: OutlinedButton.styleFrom(

                    side: BorderSide(width: 1.0, color: Colors.black),
                    primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),

                  //_homeNumが1以下の時はnullを返す
                  //こうする事でボタンを押せないようにしている
                  onPressed: (_homeNum <= 1) ? null :(){
                    debugPrint('左の仏壇を押したよ');
                    //ルーティングで画面遷移管理
                    Get.toNamed(Home.routeName + '/${_homeNum - 1}');
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      '左の仏壇へ',
                      style: ((){
                        if(_homeNum <= 1) {
                          return TextStyle(
                            color: Colors.grey[900],
                            fontSize: 24.0,
                          );
                        }else {
                          return TextStyle(
                            color: Colors.grey[900],
                            fontSize: 24.0,
                          );
                        }
                      })(),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10.0,
                ),

                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    if(/* ここで右の仏壇が登録されているか判定 */ true){
                      //登録されている場合
                      //ルーティングで画面遷移管理
                      Get.toNamed(Home.routeName + '/${_homeNum + 1}');
                    }else{
                      //仏壇ページを増やす際の処理
                      //ルーティングで画面遷移管理(仮)
                      //Get.toNamed(AddHome.routeName);
                    }
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      '右の仏壇へ',
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

                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.black),
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    //ルーティングで画面遷移管理
                    //Navigator.pushNamed(context, HogeHoge.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      'お供え',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}