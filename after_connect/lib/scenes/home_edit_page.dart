import 'package:after_connect_v2/db/budd_db.dart';
import 'package:after_connect_v2/models/budd_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../db/image_db.dart';
import '../domain/budd.dart';
import 'home.dart';

class HomeEditPage extends StatefulWidget {
  static const routeName = '/edit';
  const HomeEditPage({Key? key}) : super(key: key);
  static List<Budd>? _budd;
  static bool firstCheck = false;

  void setBudd(List<Budd> budd){
    _budd = budd;
    debugPrint('buddは→$budd');
  }

  @override
  State<HomeEditPage> createState() => _HomeEditPageState();
}


class _HomeEditPageState extends State<HomeEditPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final int _homeNum = int.parse(Get.parameters['homeNum']!);
  bool _newDataCheck = false;
  final List<Budd> _budd = HomeEditPage._budd!;
  String? _newBuddName;
  String _viewBuddName = '初期状態';

  void _set(){
    _viewBuddName = _budd.elementAt(_homeNum-1).buddName;
  }

  void _reset(){
    setState((){
      _controller.clear();
      _newDataCheck = false;
      _newBuddName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!HomeEditPage.firstCheck){
      _set();
      HomeEditPage.firstCheck = true;
    }
    return Form(
      key: _formkey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              HomeEditPage.firstCheck = false;
              Get.toNamed('${Home.routeName}/$_homeNum');
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          actions: [
            SizedBox(
              //height: 10,
              child: ElevatedButton(
                  onPressed: ()async{
                    _formkey.currentState!.validate();
                    _formkey.currentState!.save();

                    if(_newBuddName != null && _newBuddName!.isNotEmpty){
                      BuddDb().setBuddName(_budd.elementAt(_homeNum-1).buddId, _newBuddName!);
                      _newDataCheck = true;
                      _viewBuddName = _newBuddName!;
                      debugPrint("故人の名前を更新！");
                    }
                    if(_newDataCheck){
                      debugPrint("データ更新しました");
                      BuddListModel.DataCheck = false;

                      debugPrint('更新する？その１ → ${BuddListModel.DataCheck}');
                      _reset();
                    }

                    String? _imgUrl = '初期状態だよ';
                    _imgUrl = await ImageDb().imgDownloadPath('budds/${_budd.elementAt(_homeNum-1).buddId}/budd_photo.png');
                    debugPrint('$_imgUrl');
                    if(_imgUrl != null){
                      BuddDb().setBuddPhoto(_budd.elementAt(_homeNum-1).buddId, _imgUrl);
                    }
                    BuddListModel.DataCheck = false;

                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromHeight(18),
                      primary: Colors.blue,
                  ),
                  child: const Text(
                    "保存",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      locale: Locale("ja", "JP"),
                    ),
                  ),
              ),
            ),
          ],
          title: const Text('仏壇編集',style: TextStyle(color: Colors.black)),

        ),

        body: Column(
          children: [
            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  '故人の写真',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Stack(
              children: [
                Container(
                  color:Colors.red,
                  child: const SizedBox(
                    width: 100,
                    height: 100,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity:0.5,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network('${_budd.elementAt(_homeNum-1).buddPhoto}'),
                      ),
                    ),
                  ],
                ),

                ///これが編集アイコンなので一番上部に配置する
                ///でないとタップで選択できない
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    debugPrint('反応した！');
                    ImageDb().imgUpload('budds/${_budd.elementAt(_homeNum-1).buddId}/budd_photo.png');
                    await Future<void>.delayed(const Duration(milliseconds: 1000));
                    /*String? _imgUrl = '初期状態だよ';
                    _imgUrl = await ImageDb().imgDownloadPath('budds/${_budd.elementAt(_homeNum-1).buddId}/budd_photo.png');
                    debugPrint('$_imgUrl');
                    if(_imgUrl != null){
                      BuddDb().setBuddPhoto(_budd.elementAt(_homeNum-1).buddId, _imgUrl);
                    }*/
                  },
                )

              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  '故人のお名前（戒名）',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: _controller,
              //cursorColor: Colors.white,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black26,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black12,
                    width: 1.0,
                  ),
                ),
                hintText: _viewBuddName,
              ),
              /*validator: (name){
                if(name == null || name.isEmpty){
                  debugPrint('いや入力値ないが！');

                }
                return null;
              },*/
              onSaved: (value){
                _newBuddName = value;
                debugPrint('_newBuddNameに入れたのはこれだよ → $value');
              },
            ),

            const SizedBox(height: 10),
          ],
        ),

      ),
    );
  }
}
