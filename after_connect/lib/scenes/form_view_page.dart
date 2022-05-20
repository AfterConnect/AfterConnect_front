import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
//import 'package:rapid_todo/loading.dart';
//import 'package:rapid_todo/localization/localized_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FormViewPage extends StatefulWidget {
  static const routeName = '/form';

  @override
  _FormViewPageState createState() => _FormViewPageState();
}

class _FormViewPageState extends State {
  final Completer _controller = Completer();

  var connectionStatus;

  int position = 1;
  final key = UniqueKey();

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  // インターネット接続チェック
  Future check() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectionStatus = true;
      }
    } on SocketException catch (_) {
      connectionStatus = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: check(), // Future or nullを取得
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              title: const Text('お問い合わせ',style: TextStyle(color: Colors.black)),
            ),
            body: connectionStatus == true
                ? IndexedStack(
              index: position,
              children: [
                WebView(
                  initialUrl: 'https://forms.gle/jaUpWutZAhF3kBJp8',
                  javascriptMode: JavascriptMode.unrestricted, // JavaScriptを有効化
                  onWebViewCreated:
                      (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  key: key,
                  onPageFinished: doneLoading, // indexを０にしてWebViewを表示
                  onPageStarted: startLoading, // indexを1にしてプログレスインジケーターを表示
                ),
                // プログレスインジケーターを表示
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            )
            // インターネットに接続されていない場合の処理
                : SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 120,
                        bottom: 20,
                      ),
                      child: Container(),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Text(
                        'インターネットに接続されていません',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}