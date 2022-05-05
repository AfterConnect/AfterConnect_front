import 'dart:async';

import 'package:after_connect_v2/domain/budd.dart';
import 'package:after_connect_v2/scenes/make_home_dialog_page.dart';
import 'package:after_connect_v2/scenes/share_code_dialog_page.dart';
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
import '../models/budd_list_model.dart';



class Home extends StatefulWidget {
  static const routeName = '/home';
  //static final _homeNum = int.parse(Get.parameters['homeNum']!);
  //static final _buddId = UsersDb().getBuddId(user!.email, _homeNum - 1);
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _homeNum = int.parse(Get.parameters['homeNum']!);
  void _leftPage(){
    setState((){
      _homeNum--;
    });
  }
  void _rightPage(){
    setState((){
      _homeNum++;
    });
  }
  void rePage(){
    setState((){

    });
  }

  @override
  Widget build(BuildContext context){

    int _checkNum = 0;


    return MaterialApp(
      home: ChangeNotifierProvider<BuddListModel>(
        //画面が作成されたタイミングで HomeModel が発火
        create: (_) => BuddListModel()..fetchBuddList(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () async{
                debugPrint('Homeにてメニューボタンが押されました');
                //BuddDb().makeBudd();
                //String? _imgUrl = '初期状態だよ';
                //_imgUrl = await ImageDb().imgDownloadPath('default/budd/budd_photo.png');
                //debugPrint(_imgUrl);
                //debugPrint(BuddListModel());



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
                  ShareCodeDialogPage shareCode = ShareCodeDialogPage(context);
                  shareCode.setHomeNum(_homeNum);
                  shareCode.showCustomDialog();
                  //Get.toNamed(Top.routeName);
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

          body:Consumer<BuddListModel>(builder: (context, model, child) {


            if(BuddListModel.BuddListNum == null){
              debugPrint('一つ目のローディング！');
              return Container(
                color: Colors.black38,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if(BuddListModel.BuddList!.length < BuddListModel.BuddListNum!){
              debugPrint('二つ目のローディング！');
              return Container(
                color: Colors.black38,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }


            final budd = BuddListModel.BuddList;

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
                          budd.elementAt(_homeNum-1).buddName,
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
                                    child: Image.network('${budd.elementAt(_homeNum-1).buddPhoto}'),
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
                              //Get.toNamed(Home.routeName + '/${_homeNum - 1}');
                              _leftPage();

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
                            if(_homeNum >= budd.length){
                              MakeHomeDialogPage(context).showCustomDialog();
                            }else{
                              _rightPage();
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
                            BuddListModel.DataCheck = false;
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
