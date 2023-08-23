// // ignore_for_file: file_names
// import 'dart:io';
//
//
// import 'package:alataf/models/Products.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DbHelper {
//   late Database database;
//   static DbHelper dbHelper = DbHelper();
//   final String tableName = 'medicine';
//   final String productnameColumn = 'product_name';
//   final String idColumn = 'product_id';
//
//
//   initDatabase() async {
//     database = await connectToDatabase();
//   }
//
//   Future<Database> connectToDatabase() async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = '$directory/medicine.db';
//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         db.execute(
//             'CREATE TABLE $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $productnameColumn TEXT)');
//       },
//       onUpgrade: (db, oldVersion, newVersion) {
//         db.execute(
//             'CREATE TABLE $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $productnameColumn TEXT)');
//       },
//       onDowngrade: (db, oldVersion, newVersion) {
//         db.delete(tableName);
//       },
//     );
//   }
//
//   Future<List<ProductItem>> getAllRecipes() async {
//     List<Map<String, dynamic>> tasks = await database.query(tableName);
//     return tasks.map((e) => ProductItem.fromJson(e)).toList();
//   }
//
//   insertNewRecipe(ProductItem recipeModel) {
//     ProductItem productItem=ProductItem(productName: recipeModel.productName );
//     database.insert(tableName, productItem.toJson());
//   }
//
//   // deleteRecipe(RecipeModel recipeModel) {
//   //   database
//   //       .delete(tableName, where: '$idColumn=?', whereArgs: [recipeModel.id]);
//   // }
//
//   deleteRecipes() {
//     database.delete(tableName);
//   }
//
//   // updateRecipe(RecipeModel recipeModel) async {
//   //   await database.update(
//   //       tableName,
//   //       {
//   //         isFavoriteColumn: recipeModel.isFavorite ? 1 : 0,
//   //         nameColumn: recipeModel.name,
//   //         preperationTimeColumn: recipeModel.preperationTime,
//   //         imageColumn: recipeModel.image!.path,
//   //         ingredientsColumn: recipeModel.ingredients,
//   //         instructionsColumn: recipeModel.instructions
//   //       },
//   //       where: '$idColumn=?',
//   //       whereArgs: [recipeModel.id]);
//   // }
//
//   // updateIsFavorite(RecipeModel recipeModel) {
//   //   database.update(
//   //       tableName, {isFavoriteColumn: !recipeModel.isFavorite ? 1 : 0},
//   //       where: '$idColumn=?', whereArgs: [recipeModel.id]);
//   // }
// }
