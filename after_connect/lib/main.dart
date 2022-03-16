import 'package:after_connect_v2/scenes/unknown_route_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'scenes/top.dart';
import 'scenes/login_page.dart';
import 'scenes/signup_page.dart';
import 'scenes/home.dart';
import 'scenes/unknown_route_page.dart';
import 'scenes/menu.dart';
import 'util/authentication.dart';


User? userGoogle;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      GetMaterialApp(
        title: 'After Connect',
        unknownRoute: GetPage(name: '/404',page: () => const UnknownRoutePage()),
        initialRoute: Authentication.autoLogin(),
        getPages: [
          GetPage(name:Top.routeName,page: () => const Top()),
          GetPage(
            name: LoginPage.routeName,
            page: (){
              return const LoginPage();
            }
          ),
          GetPage(
            name: SignUpPage.routeName,
            page: (){
              return const LoginPage();
            }
          ),

          GetPage(
              name: Home.routeName + '/:homeNum',
              page: () => const Home(),
          ),

          GetPage(name: Menu.routeName, page: () => const Menu()),


        ],

      )
  );
}









