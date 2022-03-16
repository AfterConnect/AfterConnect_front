import 'package:after_connect_v2/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
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
    if(FirebaseAuth.instance.currentUser != null){
      userGoogle = FirebaseAuth.instance.currentUser;
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


  /// Googleサインアウトの処理メソッド
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

}