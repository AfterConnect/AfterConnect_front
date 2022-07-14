import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../db/budd_db.dart';
import '../db/users_db.dart';
import '../domain/budd.dart';
import '../models/budd_list_model.dart';
import '../db/user_to_budd_db.dart';
import 'modal_overlay.dart';
import 'home.dart';

class AddHomeDialogPage {

  BuildContext context;
  AddHomeDialogPage(this.context) : super();

  final _formkey = GlobalKey<FormState>();
  String? _shareCode;
  List<Budd>? budd;
  int? userId;
  final _db = FirebaseFirestore.instance;

  void setBudd(List<Budd> budd){
    this.budd = budd;
  }
  void setUserId(int userId){
    this.userId = userId;
  }
  int? getUserId(){
    return userId;
  }

  /*
   * 表示
   */
  void showCustomDialog() {

    Navigator.push(
      context,
      ModalOverlay(
        Form(
          key: _formkey,
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Column(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                                    " 共有コードの使用 ",
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
                                    "  追加する仏壇の共有コードを入力してください  ",
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

                      const SizedBox(
                        height: 10,
                      ),


                      SizedBox(
                        width: 250,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          child: TextFormField(
                            //cursorColor: Colors.white,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                              hintText: '共有コード',
                            ),
                            validator: (code){
                              if(code == null || code.isEmpty || code.length != 10){
                              return '10桁の共有コードを入力して下さい';
                              }else{
                                return null;
                              }
                            },
                            onSaved: (value){
                              _shareCode = value!;
                            },
                          ),
                        ),
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
                          onPressed: ()async{
                            _formkey.currentState!.validate();
                            _formkey.currentState!.save();
                            if(_shareCode != null && _shareCode!.isNotEmpty && _shareCode!.length == 10) {
                              debugPrint('入力された共有コードは「$_shareCode」です');
                              bool check = false;

                              for(int i = 0; i < budd!.length; i++){
                                if(budd!.elementAt(i).buddId == _shareCode){
                                  check = true;
                                }
                              }
                              if(check){
                                Get.defaultDialog(
                                  title: '既に登録されている仏壇です',
                                  middleText: '',
                                  textCancel: '戻る',
                                );
                              }else {
                                await BuddDb().checkIsUsed(_shareCode).then((
                                    value) async {
                                  if (value == true) {
                                    while(userId == null || userId == 0){
                                      await Future<void>.delayed(const Duration(milliseconds: 10));
                                    }
                                    UserToBuddDb().connectId(userId!, _shareCode!);
                                    //UsersDb().setBuddId(_shareCode!);
                                    await Future<void>.delayed(
                                        const Duration(milliseconds: 500));
                                    BuddListModel.DataCheck = false;

                                    /// 中間テーブル(user_to_budd)からユーザIDと紐づいている、
                                    /// かつ先程作ったばかりの未使用(isUsed = false)のものを1つ抽出
                                    QuerySnapshot userSnapshot = await _db.collection("user_to_budd").where("userId",isEqualTo: userId!).where("buddId",isEqualTo: _shareCode!).where("isUsed",isEqualTo: false).limit(1).get();
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
                                    await Future<void>.delayed(const Duration(milliseconds: 1000));

                                    Get.offAllNamed(
                                        '${Home.routeName}/${BuddListModel
                                            .BuddListNum! + 1}');
                                    Get.defaultDialog(
                                      title: '新しい仏壇を追加しました',
                                      middleText: '',
                                      textCancel: '戻る',
                                    );
                                  } else {
                                    Get.defaultDialog(
                                      title: '仏壇が存在しません',
                                      middleText: '',
                                      textCancel: '戻る',
                                    );
                                  }
                                });
                              }

                              //キーボードを閉じる
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          },
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