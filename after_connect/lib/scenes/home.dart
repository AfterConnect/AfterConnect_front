import 'dart:async';

import 'package:after_connect_v2/domain/budd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'top.dart';
import 'menu.dart';
import '../db/users_db.dart';
import '../db/budd_db.dart';
import '../db/image_db.dart';
import '../models/home_model.dart';


class Home extends StatelessWidget {
  static const routeName = '/home';
  //static final _homeNum = int.parse(Get.parameters['homeNum']!);
  //static final _buddId = UsersDb().getBuddId(user!.email, _homeNum - 1);
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    final _homeNum = int.parse(Get.parameters['homeNum']!);
    int _checkNum = 0;
    //final _buddId = UsersDb().getBuddId(user!.email, _homeNum - 1);

    //Timer(const Duration(milliseconds: 10),HomeModel());

    return MaterialApp(
      //title:'仏壇ホーム',
      home: ChangeNotifierProvider<HomeModel>(
        //画面が作成されたタイミングで HomeModel が発火
        create: (_) => HomeModel(_homeNum),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () async{
                debugPrint('Homeにてメニューボタンが押されました');
                //BuddDb().makeBudd();
                String? _imgUrl = '初期状態だよ';
                _imgUrl = await ImageDb().imgDownloadPath('default/budd/budd_photo.png');
                debugPrint(_imgUrl);
                Get.toNamed(Menu.routeName)!.then((value) {
                  user = FirebaseAuth.instance.currentUser;
                });
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

          body:Consumer<HomeModel>(builder: (context, model, child) {


            if(model.buddId == null){
              debugPrint('一つ目のローディング！');
              return Container(
                color: Colors.black38,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              /*return Center(
                child:Container(
                  color: Colors.grey,
                  child: const CircularProgressIndicator(),
                ),
              );*/

            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              //model.fetchBuddInfo();
              if(model.budd == null){
                if(_checkNum == 0){
                  debugPrint('二つ目のローディング！その１！');
                  //WidgetsBinding.instance!.addPostFrameCallback((_) {
                    model.fetchBuddInfo();
                  //});
                  _checkNum = 1;
                }
                debugPrint('二つ目のローディング！その２！');
                //return const CircularProgressIndicator();
              }
            });


            final budd = model.budd;

            debugPrint('Columuを作り始めたよ！');
            if(budd == null){
              debugPrint('buddの中身がないよ〜');
              return Container(
                color: Colors.black38,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }else {
              return Stack(

                children: <Widget>[
                  Center(
                    //child: SizedBox(
                      child: Image.network(
                          'https://cdn.discordapp.com/attachments/944112736705585222/966699651229155378/2E1193B7-6FDF-49C1-B82B-C417D0BE679C.jpg'),
                    //),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          budd.buddName,
                          style: const TextStyle(
                              backgroundColor: Colors.black12,
                              fontSize: 40.0
                          ),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    flex: 2,
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Center(
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.network('${budd.buddPhoto}'),
                                  ),
                                ),
                                onTap: () async {
                                  debugPrint('反応した！');
                                  ImageDb().imgUpload(
                                      'budds/test$_homeNum/budd_photo.png');
                                },
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              (() {
                                if (user != null) {
                                  debugPrint(user?.displayName);
                                  return Text(
                                    'ログインユーザー名：${user?.displayName}',
                                    style: const TextStyle(
                                        fontSize: 20.0
                                    ),
                                  );
                                } else {
                                  return const Text(
                                    'ログインしていません',
                                    style: TextStyle(
                                        fontSize: 20.0
                                    ),
                                  );
                                }
                              })(),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 50.0,
                      horizontal: 50.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        ///_homeNumが1以上の時のみ表示
                        Visibility(
                          visible: (_homeNum > 1),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(

                              side: const BorderSide(
                                  width: 1.0, color: Colors.black),
                              primary: Colors.white,
                              backgroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(10),
                            ),

                            onPressed: () {
                              debugPrint('左の仏壇を押したよ');
                              //ルーティングで画面遷移管理
                              Get.toNamed(Home.routeName + '/${_homeNum - 1}');
                            },

                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                              child: Text(
                                '左の仏壇へ',
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10.0,
                        ),

                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                width: 1.0, color: Colors.black),
                            // primary: Colors.white,
                            backgroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(10),
                          ),
                          onPressed: () {
                            if (/* ここで右の仏壇が登録されているか判定 */ true) {
                              //登録されている場合
                              //ルーティングで画面遷移管理
                              Get.toNamed(Home.routeName + '/${_homeNum + 1}');
                            } else {
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
                            child: Text(
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
                            side: const BorderSide(
                                width: 1.0, color: Colors.black),
                            // primary: Colors.white,
                            backgroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(10),
                          ),
                          onPressed: () {
                            //ルーティングで画面遷移管理
                            //Navigator.pushNamed(context, HogeHoge.routeName);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            child: Text(
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
              );
            }
          },
          ),
        ),
      ),
    );
  }
}
