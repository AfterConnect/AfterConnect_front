import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import '../main.dart';
import '../util/authentication.dart';
import '../db/budd_db.dart';


class LoginPage extends StatelessWidget{
  static const routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);


  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);



  Future<String?> _signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) async{
      debugPrint('デバグですぅ：_signupConfirmが呼び出されました');

      FutureBuilder(
        future: Authentication.initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            /// エラー発生時
            return const Text('初期化中にエラーが発生');
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          return const Text('正常に初期化が完了');
        },
      );

      await FirebaseAuth.instance.currentUser!.reload();
      user = FirebaseAuth.instance.currentUser;
      //await userGoogle!.reload();
      debugPrint('メール認証: ${FirebaseAuth.instance.currentUser!.emailVerified}');
      debugPrint('メール認証: ${user!.emailVerified}');

      if (user != null && user!.emailVerified) {
        debugPrint('メール認証成功');
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return null;
      }else if(user != null){
        Get.defaultDialog(
          title: 'メール認証が完了していません',
          middleText: 'メール内のリンクをクリックして下さい',
          textConfirm: '再送信',
          onConfirm: (){
            user!.sendEmailVerification();
            Get.snackbar('確認メールを再送信しました', 'メール内のリンクをクリックして下さい');
          },
          textCancel: '閉じる',
        );
        return 'メール認証が完了していません';
      }else{
        return 'メール認証に失敗しました';
      }

    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) async{
      debugPrint('デバグですぅ：_signupUserが呼び出されました');

      FutureBuilder(
        future: Authentication.initializeFirebase(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            /// エラー発生時
            return const Text('初期化中にエラーが発生');
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();

          }
          return const Text('正常に初期化が完了');
        },
      );

      user = await Authentication.signUpWithMail(data);


      if(user != null) {
        debugPrint('ユーザー登録成功');
        user = FirebaseAuth.instance.currentUser;
        return null;
      }else{
        return 'ユーザー登録に失敗しました';
      }
    });

  }

  /// メールアドレスでのログイン時処理
  Future<String?> _loginUser(LoginData data){
    return Future.delayed(loginTime).then((_) async {
      FutureBuilder(
        future: Authentication.initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            /// エラー発生時
            return const Text('初期化中にエラーが発生');
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          return const Text('正常に初期化が完了');
        },
      );

      user =
      await Authentication.signInWithMail(data.name, data.password);

      if (user != null && user!.emailVerified) {
        debugPrint('ログイン成功');
        return null;
      }else if(user != null){
          //userGoogle!.sendEmailVerification();
          Get.defaultDialog(
            title: 'メール認証が完了していません',
            middleText: '確認メール内のリンクをクリックして下さい',
            textConfirm: '再送信',
            onConfirm: (){
              user!.sendEmailVerification();
              Get.snackbar('確認メールを再送信しました', 'メール内のリンクをクリックして下さい');
            },
            textCancel: '閉じる',
          );
          return 'メール認証が完了していません';
      }else{
        return 'ログインに失敗しました';
      }
    });
  }

  ///パスワード再設定時の処理
  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) async{
      if(await Authentication.recoverPasswordOfMail(name) == true){
        return null;
      }else{
        return 'パスワードの再設定時にエラーが発生しました';
      }
    });
  }


  @override
  Widget build(BuildContext context) {
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
        title: Text(Get.arguments[1],style: const TextStyle(
          color: Colors.black,
        ),),

      ),

      extendBodyBehindAppBar: true,

      body: FlutterLogin(
        navigateBackAfterRecovery: true,
        //onConfirmSignup: _signupConfirm,
        loginAfterSignUp: false,

        loginProviders: [
          LoginProvider(
            icon: FontAwesomeIcons.google,
            label: 'Google',

            /// callback の中にボタンを押された時の処理を書く
            /// 処理がうまくいった時は null を返す
            callback: () async {

              FutureBuilder(
                future: Authentication.initializeFirebase(),
                builder: (context, snapshot) {
                  if(snapshot.hasError){
                    /// エラー発生時
                    return const Text('初期化中にエラーが発生');
                  }
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();

                  }
                  return const Text('正常に初期化が完了');
                },
              );
              user = await Authentication.signInWithGoogle(context: context);

              if(user != null){
                return null;
              }else{
                return 'もう一度お試しください';
              }



            },
          ),
        ],

        termsOfService: [
          TermOfService(
              id: 'newsletter',
              mandatory: false,
              text: 'Newsletter subscription'),
          TermOfService(
              id: 'general-term',
              mandatory: true,
              text: '利用規約',
              linkUrl: 'https://github.com/NearHuscarl/flutter_login'),
        ],
        additionalSignupFields: [
          const UserFormField(
              keyName: 'ニックネーム', icon: Icon(FontAwesomeIcons.userAlt)),
          //const UserFormField(keyName: '苗字'),
          //const UserFormField(keyName: '名前'),
        ],

      // login の画面か signup の画面か選択する
      initialAuthMode: ((){
        if(Get.arguments[0]) {
          return AuthMode.login;
        }else{
          return AuthMode.signup;
        }
      })(),

      // hideProvidersTitle: false,
      // loginAfterSignUp: false,
      // hideForgotPasswordButton: true,
      // hideSignUpButton: true,
      // disableCustomPageTransformer: true,
      messages: LoginMessages(
        userHint: 'メールアドレス',
        passwordHint: 'パスワード',
        confirmPasswordHint: 'パスワード（確認）',
        recoveryCodeHint: '再設定用コード',
        confirmationCodeHint: '認証コード',
        loginButton: 'ログイン',
        signupButton: 'ユーザー登録',
        forgotPasswordButton: 'パスワードを忘れた場合',
        recoverPasswordButton: 'パスワードの再設定',
        goBackButton: '戻る',
        confirmSignupButton: '確認',
        resendCodeButton: '認証コードの再送信',
        confirmPasswordError: 'パスワードが違います',
        recoverPasswordIntro: '登録されているメールアドレスを記入して下さい',
        recoverPasswordDescription: '登録メールアドレスにパスワードの再設定用コードをお送りします',
        recoverPasswordSuccess: '再設定用コードをお送りしました',
        confirmSignupIntro: '認証コードを入力して下さい',
        confirmRecoverIntro: '再設定用コードと新しいパスワードを記入して下さい',
      //   flushbarTitleError: 'Oh no!',
      //   flushbarTitleSuccess: 'Succes!',
      //   providersTitle: 'login with'
      ),
      theme: LoginTheme(
      primaryColor: Colors.white,
      switchAuthTextColor: Colors.grey,
      //   accentColor: Colors.white,
      //   errorColor: Colors.deepOrange,
      //   pageColorLight: Colors.indigo.shade300,
      //   pageColorDark: Colors.indigo.shade500,
      //   logoWidth: 0.80,
      //   titleStyle: TextStyle(
      //     color: Colors.black,
      //     fontFamily: 'Quicksand',
      //     letterSpacing: 4,
      //   ),
      //   // beforeHeroFontSize: 50,
      //   // afterHeroFontSize: 20,
      //   bodyStyle: TextStyle(
      //     fontStyle: FontStyle.italic,
      //     decoration: TextDecoration.underline,
      //     color: Colors.black,
      //   ),
      //   textFieldStyle: TextStyle(
      //     color: Colors.black,
      //  shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
      //   ),
      //   buttonStyle: TextStyle(
      //     fontWeight: FontWeight.w800,
      //     color: Colors.black,
      //   ),
      /*cardTheme: CardTheme(
             color: Colors.white,
        //     elevation: 5,
        //     margin: EdgeInsets.only(top: 15),
             shape: ContinuousRectangleBorder(
                 borderRadius: BorderRadius.circular(100.0)),
           ),*/
      //   inputTheme: InputDecorationTheme(
      //     filled: true,
      //     fillColor: Colors.red,
      //     contentPadding: EdgeInsets.zero,
      //     errorStyle: TextStyle(
      //       backgroundColor: Colors.orange,
      //       color: Colors.white,
      //     ),
      //     labelStyle: TextStyle(
      //         color: Colors.black,
      //         fontSize: 12,
      //     ),
      //     enabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //     errorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedErrorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
      //       borderRadius: inputBorder,
      //     ),
      //     disabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.grey, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //   ),
      buttonTheme: const LoginButtonTheme(
        splashColor: Colors.purple,
        backgroundColor: Colors.lightBlueAccent,
        highlightColor: Colors.lightBlueAccent,
        //     elevation: 9.0,
        //     highlightElevation: 6.0,
        //     shape: BeveledRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        //     // shape: CircleBorder(side: BorderSide(color: Colors.green)),
        //     // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
           ),
         ),

        userValidator: (value) {
          if (!value!.contains('@') || !value.contains('.')) {
            return "@ と . を含んだ Emailアドレスを入力して下さい";
          }
          return null;
        },
        passwordValidator: (value) {
          if (value!.isEmpty) {
            return 'パスワードが入力されていません';
          }else if(value.length < 6){
            return 'パスワードは6文字以上にして下さい';
          }
          return null;
        },

        onLogin: (loginData) {
          debugPrint('Login info');
          debugPrint('Email: ${loginData.name}');
          debugPrint('Password: ${loginData.password}');
          return _loginUser(loginData);
        },


        onSignup: (signupData) {
          debugPrint('Signup info');
          debugPrint('Email: ${signupData.name}');
          debugPrint('Password: ${signupData.password}');

          signupData.additionalSignupData?.forEach((key, value) {
            debugPrint('$key: $value');
          });
          if (signupData.termsOfService.isNotEmpty) {
            debugPrint('Terms of service: ');
            for (var element in signupData.termsOfService) {
              debugPrint(
                  ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}');
            }
          }
          return _signupUser(signupData);
        },

        /// ログイン成功時の画面遷移
        onSubmitAnimationCompleted: (){
          //ルーティングで画面遷移管理
          Get.toNamed(Home.routeName + '/1');
        },


        onRecoverPassword: (name) {
          debugPrint('Recover password info');
          debugPrint('Email: $name');
          return _recoverPassword(name);
          // Show new password dialog
        },
        showDebugButtons: false,
      ),
    );
  }


}






