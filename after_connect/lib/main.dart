import 'package:after_connect_v2/scenes/unknown_route_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'scenes/top.dart';
import 'scenes/login_page.dart';
import 'scenes/signup_page.dart';
import 'scenes/home.dart';
import 'scenes/unknown_route_page.dart';


bool alreadyLogin = false;


void main() {
  runApp(
      GetMaterialApp(
        title: 'After Connect',
        unknownRoute: GetPage(name: '/404',page: () => UnknownRoutePage()),
        initialRoute: Top.routeName,
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
              page: (){
                if(alreadyLogin){
                  return const Home();
                }else{
                  return const Top();
                }
              }
          ),


        ],

      )
  );
}









