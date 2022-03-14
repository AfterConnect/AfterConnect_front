import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forgot_password_page.dart';
import 'top.dart';
import 'home.dart';
import '../main.dart';
import '../util/login_util.dart';

const users = {
  'test@gmail.com': 'test',
  'hoge@gmail.com': '12345',
};


class LoginPage extends StatelessWidget{
  static const routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) {
      debugPrint('デバグですぅ：_signupConfirmが呼び出されました');
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) {
      debugPrint('デバグですぅ：_signupUserが呼び出されました');
      return null;
    });
  }

  //ログイン時の処理
  Future<String?> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'メールアドレスが登録されていません';
      }
      if (users[data.name] != data.password) {
        return 'パスワードが違います';
      }
      debugPrint('ログイン成功');
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'メールアドレスが登録されていません';
      }
      return null;
    });
  }


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
              Navigator.pushNamed(context, Top.routeName);
            }
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
        onConfirmRecover: _signupConfirm,
        onConfirmSignup: _signupConfirm,
        loginAfterSignUp: true,
        loginProviders: [
          LoginProvider(
            icon: FontAwesomeIcons.google,
            label: 'Google',
            // callback の中にボタンを押された時の処理を書く
            // GoogleのAPIの処理はここで行う
            // 処理がうまくいった時は null を返す
            callback: () async {
              debugPrint('Googleアカウントでの認証');
              return null;
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
          const UserFormField(keyName: '苗字'),
          const UserFormField(keyName: '名前'),
          UserFormField(
            keyName: '電話番号',
            displayName: '電話番号',
            userType: LoginUserType.phone,
            fieldValidator: (value) {
              var phoneRegExp = RegExp(
                  '^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}\$');
              if (value != null &&
                  value.length < 7 &&
                  !phoneRegExp.hasMatch(value)) {
                return "正しくない電話番号です";
              }
              return null;
            },
          ),
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
      buttonTheme: LoginButtonTheme(
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

        //ログイン成功時の画面遷移
        onSubmitAnimationCompleted: () {
          alreadyLogin = true;
          //ルーティングで画面遷移管理
          //'1'の所を仏壇IDにしても良いかも
          Get.toNamed(Home.routeName + '/1');
        },


        onRecoverPassword: (name) {
          debugPrint('Recover password info');
          debugPrint('Email: $name');
          return _recoverPassword(name);
          // Show new password dialog
        },
        showDebugButtons: true,
      ),
    );
  }


}






