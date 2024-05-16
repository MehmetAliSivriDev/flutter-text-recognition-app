import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/home/model/image_model.dart';

class DbHelper {
  String tblName = "images";
  String colId = "id";
  String colFileName = "fileName";
  String colFilePath = "filePath";

  DbHelper._internal();
  static final DbHelper _dbHelper = DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await createDb();
    }
    return _db!;
  }

  Future<Database> createDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "image_history.db";
    var bursamDb = await openDatabase(path, version: 1, onCreate: create);
    return bursamDb;
  }

  void create(Database db, int version) async {
    await db.execute(
        "Create table $tblName ($colId integer primary key autoincrement,$colFileName text,$colFilePath text)");
  }

  //QUERIES
  Future<List<ImageModel>> getImages() async {
    Database db = await this.db;
    var results = await db.rawQuery("Select * from $tblName");

    List<ImageModel> images = [];

    for (var result in results) {
      var id = result['id'];
      var filePath = result['filePath'];

      late int imageId;
      late File file;

      if (id != null) {
        imageId = int.parse(id.toString());
      }

      if (filePath != null) {
        String filePathString = filePath.toString();
        file = File(filePathString);
      }

      ImageModel model = ImageModel(id: imageId, file: file);
      images.add(model);
    }

    return images;
  }

  Future<int> imageAdd(File image) async {
    Database db = await this.db;
    String fileName = image.path.split('/').last;
    String filePath = image.path;

    var result =
        await db.insert(tblName, {'fileName': fileName, 'filePath': filePath});
    return result;
  }

  Future<int> imageDelete(int id) async {
    Database db = await this.db;
    var result = await db.rawDelete("Delete from $tblName where $colId = $id");
    return result;
  }

  //----------------------------------------------------------
}
