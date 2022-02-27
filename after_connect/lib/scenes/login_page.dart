import 'package:after_connect_v2/model/login_model.dart';
import 'package:flutter/material.dart';
import 'forgot_password_page.dart';
import '../util/login_util.dart';
import '../model/login_model.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginRequestModel? requestModel;
  @override
  void initState(){
    super.initState();
    requestModel = LoginRequestModel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('ログイン',style: TextStyle(
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

            const SizedBox(
              height: 50.0,
            ),
            EmailInputField(),
            const SizedBox(
              height: 20.0,
            ),
            PasswordInputField(),
            LoginButton(),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                  );
                },
                child: const Text(
                  'パスワードを忘れた場合',
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


