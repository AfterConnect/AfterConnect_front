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


class Home extends StatefulWidget {
  static const routeName = '/home';

  const Home({Key? key}) : super(key: key);

  //final String homeNumber;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //いくつ目の仏壇のかを表す変数
  //初期値は１
  final _homeNum = int.parse(Get.parameters['homeNum']!);
  //List? _buddsList = await UsersDb(user.email!);
  String? _buddId = UsersDb().getBuddId(user!.email, int.parse(Get.parameters['homeNum']!)-1);


  void _rePage(){
    setState(() async{
      user = FirebaseAuth.instance.currentUser;
      //_buddId = UsersDb().getBuddId(user!.email, _homeNum-1);
    });
  }


  @override
  Widget build(BuildContext context){
    //BuddDb().makeBudd();
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
                BuddDb().makeBudd();
                String? _imgUrl = '初期状態だよ';
                _imgUrl = await ImageDb().imgDownloadPath('default/budd/budd_photo.png');
                debugPrint(_imgUrl);
                Get.toNamed(Menu.routeName)!.then((value) => _rePage());
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
              return Column(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        //debugPrint(''),
                        Text(
                          model.buddName,
                          style: const TextStyle(
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
                        SizedBox(
                          //width: 300,
                          //height: 350,

                          //child: Container(color: Colors.grey,),
                          child:Image.network('https://4.bp.blogspot.com/-vpajUL6jZkw/VMIu9i4l5aI/AAAAAAAAq2M/TPYfH7t6kXQ/s800/butsudan.png'),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            //if(_buddId != null)Image.network(_buddId!),
                            //Image.network(_buddId!),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child:Container(
                                      child: Image.network('${model.buddPhoto}'),
                                      //color: Colors.grey,
                                    ),
                                  ),
                                  onTap:() async{
                                    debugPrint('反応した！');
                                    ImageDb().imgUpload('budds/test$_homeNum/budd_photo.png');
                                  },
                                ),
                              ],
                            ),


                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ((){
                              if (user != null) {

                                debugPrint(user?.displayName);
                                return Text(
                                  'ログインユーザー名：${user?.displayName}',
                                  style: const TextStyle(
                                      fontSize: 20.0
                                  ),
                                );
                              }else {
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

                        ///_homeNumが1以上の時のみ表示
                        Visibility(
                          visible: (_homeNum > 1),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(

                              side: const BorderSide(width: 1.0, color: Colors.black),
                              primary: Colors.white,
                              minimumSize: const Size.fromHeight(10),
                            ),

                            onPressed: (){
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
                                style:TextStyle(
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
              );
            },
          ),
        ),
      ),
    );
  }

}