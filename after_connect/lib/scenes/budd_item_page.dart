import 'package:after_connect_v2/domain/budd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../db/budd_db.dart';
import '../db/users_db.dart';
import '../models/budd_list_model.dart';
import 'modal_overlay.dart';
import 'home.dart';

class BuddItemPage {

  BuildContext context;
  BuddItemPage(this.context) : super();

  final _formkey = GlobalKey<FormState>();
  String? _shareCode;
  int? _homeNum;
  List<Budd>? budd;

  void setHomeNum(int homeNum){
    _homeNum = homeNum;
  }
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
                                children: <Widget>[

                                  /*
                                 * タイトル
                                 */
                                  const Text(
                                    "お供物を選択してください",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      locale: Locale("ja", "JP"),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 15.0,
                                  ),

                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 90.0,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                    width: 1.0, color: Colors.black),
                                                backgroundColor: budd!.elementAt(_homeNum!-1).buddItems['hana'] == true ?
                                                                                  Colors.grey:Colors.white,
                                                minimumSize: const Size.fromHeight(10),
                                              ),
                                              onPressed: budd!.elementAt(_homeNum!-1).buddItems['hana'] == true ? null
                                                  :() {
                                                BuddDb().useBuddItem(budd!.elementAt(_homeNum!-1).buddId, 'hana').then((value){
                                                  BuddListModel.DataCheck = false;
                                                  hideCustomDialog();
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 10.0,
                                                ),
                                                child: Text(
                                                  'お花',
                                                  style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          SizedBox(
                                            width: 90.0,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                    width: 1.0, color: Colors.black),
                                                backgroundColor: budd!.elementAt(_homeNum!-1).buddItems['kome'] == true ?
                                                                                  Colors.grey:Colors.white,
                                                minimumSize: const Size.fromHeight(10),
                                              ),
                                              onPressed: budd!.elementAt(_homeNum!-1).buddItems['kome'] == true ? null
                                                  :() {
                                                BuddDb().useBuddItem(budd!.elementAt(_homeNum!-1).buddId, 'kome').then((value){
                                                  BuddListModel.DataCheck = false;
                                                  hideCustomDialog();
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 10.0,
                                                ),
                                                child: Text(
                                                  'ご飯',
                                                  style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 10.0,
                                          ),

                                          SizedBox(
                                            width: 120.0,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                    width: 1.0, color: Colors.black),
                                                backgroundColor: budd!.elementAt(_homeNum!-1).buddItems['toumyou'] == true ?
                                                                                  Colors.grey:Colors.white,
                                                minimumSize: const Size.fromHeight(10),
                                              ),
                                              onPressed: budd!.elementAt(_homeNum!-1).buddItems['toumyou'] == true ? null
                                                  :() {
                                                BuddDb().useBuddItem(budd!.elementAt(_homeNum!-1).buddId, 'toumyou').then((value){
                                                  BuddListModel.DataCheck = false;
                                                  hideCustomDialog();
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 10.0,
                                                ),
                                                child: Text(
                                                  'ろうそく',
                                                  style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 8.0,
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 90.0,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                    width: 1.0, color: Colors.black),
                                                backgroundColor: budd!.elementAt(_homeNum!-1).buddItems['mizu'] == true ?
                                                                                  Colors.grey:Colors.white,
                                                minimumSize: const Size.fromHeight(10),
                                              ),
                                              onPressed: budd!.elementAt(_homeNum!-1).buddItems['mizu'] == true ? null
                                                  :() {
                                                BuddDb().useBuddItem(budd!.elementAt(_homeNum!-1).buddId, 'mizu').then((value){
                                                  BuddListModel.DataCheck = false;
                                                  hideCustomDialog();
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 10.0,
                                                ),
                                                child: Text(
                                                  'お水',
                                                  style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          SizedBox(
                                            width: 90.0,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                    width: 1.0, color: Colors.black),
                                                backgroundColor: budd!.elementAt(_homeNum!-1).buddItems['kou'] == true ?
                                                                                  Colors.grey:Colors.white,
                                                minimumSize: const Size.fromHeight(10),
                                              ),

                                              onPressed:budd!.elementAt(_homeNum!-1).buddItems['kou'] == true ? null
                                                :() {
                                                BuddDb().useBuddItem(budd!.elementAt(_homeNum!-1).buddId, 'kou').then((value){
                                                  BuddListModel.DataCheck = false;
                                                  hideCustomDialog();
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 10.0,
                                                ),
                                                child: Text(
                                                  '線香',
                                                  style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
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
                        onPressed: ()async{
                          hideCustomDialog();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white
                        ),
                        child: const Text(
                          "キャンセル",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            locale: Locale("ja", "JP"),
                          ),
                        ),
                      ),

                      /*const SizedBox(
                        width: 10.0,
                      ),*/

                      /*ElevatedButton(
                        child: const Text(
                          "キャンセル",
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
                      ),*/
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

    Navigator.of(context).pop(budd);
  }
}