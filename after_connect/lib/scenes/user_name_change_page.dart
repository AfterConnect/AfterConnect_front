import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../main.dart';


class UserNameChangePage extends StatefulWidget {
  static const routeName = '/name';
  const UserNameChangePage({Key? key}) : super(key: key);

  @override
  _UserNameChangePageState createState() => _UserNameChangePageState();
}



class _UserNameChangePageState extends State<UserNameChangePage> {

  final _formkey = GlobalKey<FormState>();
  String _userName = user!.displayName!;

  void _reName(){
    setState((){
      user = FirebaseAuth.instance.currentUser;
      _userName = user!.displayName!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('ユーザー名変更',style: TextStyle(color: Colors.black)),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),

      body: Form(
        key: _formkey,
        child: Column(
          children:<Widget>[
            Text('現在のユーザー名：$_userName'),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '新しいユーザー名',
              ),
              validator: (name){
                if(name == null || name.isEmpty){
                  return '新しいユーザー名を入力して下さい';
                }
                return null;
              },
              onSaved: (value){
                _userName = value!;
              },
            ),
            ElevatedButton(
                onPressed: ()async{
                  _formkey.currentState!.save();
                  await user!.updateDisplayName(_userName);
                  _reName();
                  Get.defaultDialog(
                    title: 'ユーザー名を変更しました',
                    middleText: '',
                    textCancel: '戻る',
                  );
                  //キーボードを閉じる
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: const Text('変更')),
          ],
        ),
      ),
    );
  }
}
