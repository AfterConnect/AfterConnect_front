import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
//import 'package:rapid_todo/loading.dart';
//import 'package:rapid_todo/localization/localized_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';

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
    final Size size = MediaQuery.of(context).size;
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
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
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomSpace),
                child: connectionStatus == true
                    ? IndexedStack(
                  index: position,
                  children: [
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "あなたのメールアドレス",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            locale: Locale("ja", "JP"),
                          ),
                        ),

                        /*
                         * メッセージ
                         */
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                left: 50,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black12,
                                border: Border.all(color: Colors.black),
                              ),
                              child: Text(
                                "  ${user!.email}  ",
                                style: const TextStyle(
                                  //backgroundColor: Colors.black12,
                                  fontSize: 18.0,
                                  locale: Locale("ja", "JP"),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed:()async{
                                /// コピーするとき
                                final data = ClipboardData(text: '${user!.email}');
                                await Clipboard.setData(data);
                              },
                              icon: const Icon(Icons.content_copy),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height*0.75,
                          child: WebView(
                            initialUrl: 'https://docs.google.com/forms/d/e/1FAIpQLSd7JKU9673EUtMOqJhg6JqgcOiVfzNrZ0SpG7mj--GTv7_wmw/viewform?usp=sf_link',
                            javascriptMode: JavascriptMode.unrestricted, // JavaScriptを有効化
                            onWebViewCreated:
                                (WebViewController webViewController) {
                              _controller.complete(webViewController);
                            },
                            key: key,
                            onPageFinished: doneLoading, // indexを０にしてWebViewを表示
                            onPageStarted: startLoading, // indexを1にしてプログレスインジケーターを表示
                          ),
                        ),

                      ],
                    ),

                    // プログレスインジケーターを表示
                    const Center(
                      child: LinearProgressIndicator(),
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
              ),
            ),
          );
        }
        );
  }
}