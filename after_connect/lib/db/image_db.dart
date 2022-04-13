import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'dart:io';
import 'users_db.dart';
import '../main.dart';

class ImageDb {
  File? imageFile;

  ///引数で与えられたパスへ画像をアップロード
  void imgUpload(String imgPath) async {
    // imagePickerで画像を選択する
    // upload
    final pickerFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (pickerFile != null) {
      imageFile = File(pickerFile.path);
    }

    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage.ref(imgPath).putFile(imageFile!);
    } catch (e) {
      debugPrint('$e');
    }
  }

  ///引数で与えられたパスの画像URLを返す
  Future<String?> imgDownloadPath(String imgPath) async {
    FirebaseStorage storage = await FirebaseStorage.instance;
    Reference imageRef = storage.ref(imgPath);
    String _imgUrl = await imageRef.getDownloadURL();
    debugPrint(_imgUrl);
    return _imgUrl;
    //return await imageRef.getDownloadURL();
  }
}