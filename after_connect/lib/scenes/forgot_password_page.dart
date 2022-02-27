import 'package:flutter/material.dart';
import '../util/login_util.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
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
        title: const Text('パスワードを忘れた場合',style: TextStyle(
          color: Colors.black,
        ),),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            const SizedBox(
              height: 50.0,
            ),
            EmailInputField(),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 60,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1.0, color: Colors.black),
                        // primary: Colors.white,
                        minimumSize: const Size.fromHeight(10),
                      ),
                      onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const SignUpPage()),
                        // );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 10.0,
                        ),
                        child:Text(
                          '送信',
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'メールアドレスにURLを送ります',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}