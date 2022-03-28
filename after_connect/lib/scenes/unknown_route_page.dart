import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'top.dart';

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '404ですよぉ！！',
                  style: TextStyle(
                      fontSize: 50.0
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child:Image.network('data:image/jpeg;base64,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'),
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
                    // primary: Colors.white,
                    minimumSize: const Size.fromHeight(10),
                  ),
                  onPressed: (){
                    //ルーティングで画面遷移管理
                    Get.toNamed(Top.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child:Text(
                      'Top画面に戻る',
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