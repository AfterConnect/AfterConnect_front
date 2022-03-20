import 'package:after_connect_v2/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

import '../scenes/home.dart';
import '../scenes/top.dart';
import '../scenes/login_page.dart';


class Authentication {

  /// Firebaseの初期化メソッド
  static Future<FirebaseApp> initializeFirebase() async {
    /// 初期化
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  /// オートログインメソッド
  /// 適切なルートを返す
  /// ログイン済みならuserGoogleにユーザー情報を入れる
  static String autoLogin(){
    debugPrint('オートログインを実行');
    if(FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.emailVerified){
      user = FirebaseAuth.instance.currentUser;
      return '${Home.routeName}/1';
    }else{
      return Top.routeName;
    }

  }


  /// Googleログイン用のメソッド
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    
    final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
              await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          Get.snackbar('認証に失敗しました', 'このアカウントは別の認証情報ですでに存在しています。');
          debugPrint('認証に失敗しました: このアカウントは別の認証情報ですでに存在しています。');
        }
        else if (e.code == 'invalid-credential') {
          Get.snackbar('エラーが発生しました', 'アクセス中にエラーが発生しました。もう一度お試し下さい。');
          debugPrint('エラーが発生しました: アクセス中にエラーが発生しました。もう一度お試し下さい。');
        }
      } catch (e) {
        Get.snackbar('エラーが発生しました', 'Googleサインイン時にエラーが発生しました。もう一度お試し下さい。');
        debugPrint('エラーが発生しました: Googleサインイン時にエラーが発生しました。もう一度お試し下さい。');
      }
    }

    return user;
  }


  /// サインアウトの処理メソッド
  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Get.snackbar('エラーが発生しました', 'Googleサインアウト時にエラーが発生しました。もう一度お試し下さい。');
      debugPrint('エラーが発生しました: Googleサインアウト時にエラーが発生しました。もう一度お試し下さい。');
    }
  }



  /// メールアドレスログイン用の処理メソッド
  static Future<User?> signInWithMail(_email,_password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      //メールアドレス・パスワードが登録されているか確認
      UserCredential _result = await auth.signInWithEmailAndPassword(
          email: _email,
          password: _password
      );

      //ログイン成功時、ログインユーザーを取得
      user = _result.user;

    } on FirebaseAuthException catch(e){
      Get.defaultDialog(
        title:
        ((){
          if (e.code == 'invalid-email') {
            return 'メールアドレスの形式が異なります';
          } else if(e.code == 'user-disabled') {
            return '無効なユーザーです';
          } else if(e.code == 'user-not-found') {
            return 'ユーザーが存在しません';
          } else if(e.code == 'wrong-password') {
            return 'パスワードが間違っています';
          } else if (e.code == 'too-many-requests') {
            return 'パスワードの入力回数上限に達しました';
          } else {
            return '予期せぬエラーが発生しました';
          }
        })(),
        middleText: 'ログインに失敗しました',
        textCancel: '戻る',
      );
      debugPrint('メールアドレスでのログイン時にエラー発生 ErrorCode: ${e.code}');
    }

    return user;
  }


  ///メールアドレスユーザー登録用メソッド
  static Future<User?> signUpWithMail(SignupData date) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try{
      //メールアドレス・パスワードを登録
      UserCredential _result = await auth.createUserWithEmailAndPassword(
          email: date.name!,
          password: date.password!
      );
      // 以下、登録成功時
      user = _result.user!;
      // 確認メールを送信
      await user.sendEmailVerification();
      // 表示名に入力したニックネームを設定
      await user.updateDisplayName(date.additionalSignupData?['ニックネーム']);

    } on FirebaseAuthException catch(e) {
      Get.defaultDialog(
        title:
          ((){
            if (e.code == 'email-already-in-use') {
              return '指定したメールアドレスは登録済みです';
            } else if (e.code == 'invalid-email') {
              return 'メールアドレスのフォーマットが正しくありません';
            } else if (e.code == 'operation-not-allowed') {
              return '指定したメールアドレス・パスワードは現在使用できません';
            } else if (e.code == 'weak-password') {
              return 'パスワードは６文字以上にしてください';
            } else {
              return '予期せぬエラーが発生しました';
            }
          })(),
        middleText:'ユーザー登録に失敗しました',
        textCancel: '戻る',
      );
    }

    return user;
  }


  ///パスワード再設定用メソッド
  ///再設定用メールを送信完了すればtrueを返す
  ///失敗時にはfalseを返す
  static Future<bool?> recoverPasswordOfMail(String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch(e){
      Get.defaultDialog(
          title:
      ((){
        if (e.code == 'invalid-email') {
          return '無効なメールアドレスです';
        } else if (e.code == 'missing-android-pkg-name') {
          return 'Androidのパッケージ名が異なります';
        } else if (e.code == 'missing-continue-uri') {
          return 'リクエストに継続URLを指定する必要があります';
        } else if (e.code == 'missing-ios-bundle-id') {
          return 'iosバンドルIDが異なります';
        } else if (e.code == 'invalid-continue-uri') {
          return 'パスワード変更用のURLリンクが無効です';
        } else if (e.code == 'unauthorized-continue-uri') {
          return '許可されていないドメインです';
        } else if (e.code == 'user-not-found') {
          return 'ユーザーが登録されていません';
        } else {
          return '予期せぬエラーが発生しました';
        }
      })(),
        middleText:'パスワード変更に失敗しました',
        textCancel: '戻る',
      );
      return false;
    }
  }
}