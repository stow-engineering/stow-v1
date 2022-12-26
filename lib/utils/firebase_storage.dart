// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// Project imports:
import 'package:stow/models/food_item.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
    String filePath,
    String fileName,
    String folder,
  ) async {
    File file = File(filePath);
    try {
      await storage.ref('$folder/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String>? getFoodItemImage(String name) async {
    try {
      firebase_storage.ListResult result =
          await storage.ref('FoodItemImages').listAll();
      for (int i = 0; i < result.items.length; i++) {
        var imageName = result.items[i].name.toString().split(".")[0];
        imageName = imageName.toLowerCase();
        name = name.toLowerCase();
        if (imageName == name) {
          return await result.items[i].getDownloadURL();
        }
      }
      firebase_storage.Reference stockImage =
          await storage.ref().child('FoodItemImages/stock_food.png');
      return stockImage.getDownloadURL();
    } catch (e) {
      return "HTTP_ERROR";
    }
  }
}
