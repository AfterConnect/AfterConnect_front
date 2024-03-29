import 'dart:async';

import 'package:after_connect_v2/domain/budd.dart';
import 'package:after_connect_v2/db/user_to_budd_db.dart';
import 'package:after_connect_v2/scenes/budd_item_page.dart';
import 'package:after_connect_v2/scenes/home_edit_page.dart';
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
  static const int lostTime = 60*60*24*14;
  //static int? userId;
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _homeNum = int.parse(Get.parameters['homeNum']!);
  List<Budd>? budd;
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
  void _rePage(List<Budd> newBudd){
    setState((){
      budd = newBudd;
    });
  }

  @override
  Widget build(BuildContext context){

    //debugPrint('ビルドしたよ！');
    return MaterialApp(
      home: ChangeNotifierProvider<BuddListModel>(
        ///画面が作成されたタイミングで BuddListModel、fetchBuddList() が発火
        create: (_) => BuddListModel(),
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
                //BuddDb().reset();

                Menu menu = const Menu();
                menu.setBudd(budd!);

                ///メニュー画面にてユーザー名の変更をされている可能性があるので
                ///帰ってきたら更新されるようにしてる
                Get.to(menu)!.then((value) {
                  user = FirebaseAuth.instance.currentUser;
                });
              },
              icon: const Icon(Icons.menu),
            ),

            actions: [
              IconButton(
                  onPressed: (){
                    Get.toNamed('${Home.routeName}/$_homeNum}');
                  },
                  icon: const Icon(Icons.refresh)
              ),
              IconButton(
                onPressed: (){
                  const HomeEditPage().setBudd(budd!);
                  Get.toNamed('${Home.routeName}/$_homeNum${HomeEditPage.routeName}');
                },
                icon: const Icon(Icons.edit)
              ),
              IconButton(
                onPressed: () {
                  debugPrint('Homeにて共有ボタンが押されました');
                  ShareCodeDialogPage shareCode = ShareCodeDialogPage(context);
                  shareCode.setHomeNum(_homeNum);
                  if(budd != null){
                    shareCode.setBudd(budd!);
                    shareCode.showCustomDialog();
                  }

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
            if(BuddListModel.BuddList.length < BuddListModel.BuddListNum!){
              debugPrint('二つ目のローディング！');
              return Container(
                color: Colors.black38,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if(BuddListModel.BuddList.length < _homeNum){
              debugPrint('データ更新のためのローディング！');
              return Container(
                color: Colors.black38,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }


            budd = BuddListModel.BuddList;
            int? userId;
            UsersDb().getUserId(user!.email!).then((value){
              userId = value;
            });

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
              return RefreshIndicator(
                onRefresh:()async{
                  Get.offAllNamed('${Home.routeName}/$_homeNum');
                },
                child: Stack(

                  children: <Widget>[
                    Center(
                        child: Opacity(
                          opacity: 0.7,
                          child: Image.network(
                              'http://cdn.discordapp.com/attachments/944112736705585222/966699651229155378/2E1193B7-6FDF-49C1-B82B-C417D0BE679C.jpg'
                          ),
                        ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white70,
                            ),
                            child: Text(
                              budd!.elementAt(_homeNum-1).buddName,
                              style: const TextStyle(
                                fontSize: 40.0,
                                locale: Locale("ja", "JP"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Row(
                                      children: [
                                        ///_homeNumが1以上の時のみ表示
                                        Visibility(
                                          visible: (_homeNum > 1),
                                          child: IconButton(
                                            onPressed: (){
                                              debugPrint('左の仏壇を押したよ');
                                              _leftPage();
                                            },
                                            icon: const Icon(Icons.arrow_left),
                                            color: Colors.red,
                                            iconSize: 100,
                                          ),
                                        ),
                                        Visibility(
                                          visible: (_homeNum <= 1),
                                          child: const IconButton(
                                            onPressed: null,
                                            icon: Icon(Icons.arrow_left),
                                            //color: Colors.white.withOpacity(0.0),
                                            iconSize: 100,
                                          ),
                                        ),
                                        Container(
                                          height: 140,
                                          width: 140,
                                          decoration: const BoxDecoration(
                                            color: Colors.black26,
                                          ),
                                          child: GestureDetector(
                                            child: Center(
                                              child: SizedBox(
                                                width: 140,
                                                height: 140,
                                                child: Image.network('${budd!.elementAt(_homeNum-1).buddPhoto}'),
                                              ),
                                            ),
                                            onTap: () async {
                                              debugPrint('反応した！');
                                              //ImageDb().imgUpload('budds/test$_homeNum/budd_photo.png');
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: ()async{
                                            debugPrint('右の仏壇を押したよ');
                                            if(_homeNum >= budd!.length){
                                              MakeHomeDialogPage makeHome = MakeHomeDialogPage(context);
                                              makeHome.setBudd(budd!);
                                              while(userId == null){
                                                await Future<void>.delayed(const Duration(milliseconds: 10));
                                              }
                                              makeHome.setUserId(userId!);
                                              while(makeHome.getUserId() == null && makeHome.getUserId() == 0){
                                                await Future<void>.delayed(const Duration(milliseconds: 10));
                                              }
                                              makeHome.showCustomDialog();
                                            }else{
                                              _rightPage();
                                            }
                                          },
                                          icon: const Icon(Icons.arrow_right),
                                          color: Colors.red,
                                          iconSize: 100,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              ///開発時用テキスト
                              /*Center(
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
                              ),*/

                            ],
                          ),
                        ),
                      ],
                    ),

                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 350, right: 0, bottom: 0, left: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: const Color.fromRGBO(255, 255, 255, 0.7),
                              child: SizedBox(
                                width: 65.0,
                                height: 120,
                                child: () {
                                  if((DateTime.now().difference((budd!.elementAt(_homeNum-1).buddItems['hana'])!).inSeconds) <= Home.lostTime){
                                    return Image.asset('images/hana.png');
                                  }else{
                                    return null;
                                  }
                                }(),
                              ),
                            ),
                            Container(
                              color: const Color.fromRGBO(255, 255, 255, 0.7),
                              child: SizedBox(
                                width: 65.0,
                                height: 120,
                                child: () {
                                  if((DateTime.now().difference((budd!.elementAt(_homeNum-1).buddItems['kome'])!).inSeconds) <= Home.lostTime){
                                    return Image.asset('images/kome.png');
                                  }else{
                                    return null;
                                  }
                                }(),
                              ),
                            ),
                            Container(
                              color: const Color.fromRGBO(255, 255, 255, 0.7),
                              child: SizedBox(
                                width: 65.0,
                                height: 120,
                                child: () {
                                  if((DateTime.now().difference((budd!.elementAt(_homeNum-1).buddItems['toumyou'])!).inSeconds) <= Home.lostTime){
                                    return Image.asset('images/toumyou.png');
                                  }else{
                                    return null;
                                  }
                                }(),
                              ),
                            ),
                            Container(
                              color: const Color.fromRGBO(255, 255, 255, 0.7),
                              child: SizedBox(
                                width: 65.0,
                                height: 120,
                                child: () {
                                  if((DateTime.now().difference((budd!.elementAt(_homeNum-1).buddItems['mizu'])!).inSeconds) <= Home.lostTime){
                                    return Image.asset('images/mizu.png');
                                  }else{
                                    return null;
                                  }
                                }(),
                              ),
                            ),
                            Container(
                              color: const Color.fromRGBO(255, 255, 255, 0.7),
                              child: SizedBox(
                                width: 65.0,
                                height: 120,
                                child: () {
                                  if((DateTime.now().difference((budd!.elementAt(_homeNum-1).buddItems['kou'])!).inSeconds) <= Home.lostTime){
                                    return Image.asset('images/kou.png');
                                  }else{
                                    return null;
                                  }
                                }(),
                              ),
                            ),
                          ],
                        ),
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


                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  width: 1.0, color: Colors.black),
                              // primary: Colors.white,
                              backgroundColor: Colors.white70,
                              minimumSize: const Size.fromHeight(10),
                            ),
                            onPressed: () {

                              debugPrint('Homeにてお供えボタンが押されました');
                              BuddItemPage buddItem = BuddItemPage(context);
                              buddItem.setHomeNum(_homeNum);
                              if(budd != null){
                                buddItem.setBudd(budd!);
                                buddItem.showCustomDialog();
                              }

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
                ),
              );
            }
          },
          ),
        ),
      ),
    );
  }
}
