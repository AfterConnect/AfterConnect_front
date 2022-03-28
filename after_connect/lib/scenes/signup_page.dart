import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_page.dart';
import 'top.dart';
import '../util/login_util.dart';
class SignUpPage extends StatefulWidget {
  static const routeName = '/signup';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            if(Navigator.of(context).canPop()) {
              Navigator.pop(context);
            }else{
              Get.toNamed(Top.routeName);
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('ユーザー登録',style: TextStyle(
          color: Colors.black,
        ),),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        child:ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('ユーザー名', style: TextStyle(
              fontSize: 16.0,
            ),),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '山田太郎',
                ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            EmailInputField(),
            const SizedBox(
              height: 15.0,
            ),
            PasswordInputField(),
            LoginButton(),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  //ルーティングで画面遷移管理
                  Navigator.pushNamed(context, LoginPage.routeName);
                },
                child: const Text(
                  '既にアカウントをお持ちの方',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

