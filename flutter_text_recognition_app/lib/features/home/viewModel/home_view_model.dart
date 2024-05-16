import 'package:flutter/material.dart';
import 'package:flutter_text_recognition_app/core/data/dbHelper.dart';

import '../model/image_model.dart';

class HomeViewModel extends ChangeNotifier {
  List<ImageModel>? images;

  Future<int> imageDelete(int id) async {
    DbHelper dbHelper = DbHelper();
    dbHelper.createDb().then((value) => null);
    return await dbHelper.imageDelete(id);
  }

  Future<void> getImages() async {
    DbHelper dbHelper = DbHelper();
    dbHelper.createDb().then((value) => null);
    images = await dbHelper.getImages();
    notifyListeners();
  }
}
