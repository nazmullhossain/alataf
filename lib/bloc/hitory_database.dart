
import 'dart:io';


import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Products.dart';

class DbHelper {
  late Database database;
  static DbHelper dbHelper = DbHelper();
  final String tableName = 'myhistory';
  final String productNameColumn = 'product_name';
  final String idColumn = 'id';
  final String categoryNameColumn = 'category_name';
  final String companyNameColumn = 'company_name';
  final String priceColumn = 'price';
  final String unitNameColumn = 'unit_name';
  final String genericNameColumn = 'generic_name';
  final String strengthColumn = 'strength';
  final String vatPercentColumn = 'vat_percent';


  initDatabase() async {
    database = await connectToDatabase();
  }

  Future<Database> connectToDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '$directory/myhistory.db';
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            // 'CREATE TABLE $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $productNameColumn TEXT, $priceColumn INTEGER,$vatPercentColumn INTEGER,  $categoryNameColumn TEXT, $companyNameColumn TEXT, $unitNameColumn TEXT,$genericNameColumn TEXT,$strengthColumn TEXT,)');


        'CREATE TABLE $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $productNameColumn TEXT, $priceColumn INTEGER, $vatPercentColumn INTEGER, $categoryNameColumn TEXT, $companyNameColumn TEXT, $unitNameColumn TEXT,$genericNameColumn TEXT,$strengthColumn TEXT)');



      },
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute(
            'CREATE TABLE $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $productNameColumn TEXT, $priceColumn INTEGER, $vatPercentColumn INTEGER, $categoryNameColumn TEXT, $companyNameColumn TEXT, $unitNameColumn TEXT,$genericNameColumn TEXT,$strengthColumn TEXT)');
      },
      onDowngrade: (db, oldVersion, newVersion) {
        db.delete(tableName);
      },
    );
  }

  Future<List<ProductItem>> getAllRecipes() async {
    List<Map<String, dynamic>> tasks = await database.query(tableName);

    print("data---------------------.${tasks}");


    print("lentht-------------------->${tasks.length}");
    return tasks.map((e) => ProductItem.fromJson(e)).toList();
  }

  insertNewRecipe(ProductItem recipeModel) {
    database.insert(tableName, recipeModel.toJson());
  }

  deleteRecipe(ProductItem recipeModel) {
    database
        .delete(tableName, where: '$idColumn=?', whereArgs: [recipeModel]);
  }

  deleteRecipes() {
    database.delete(tableName);

  }




}
