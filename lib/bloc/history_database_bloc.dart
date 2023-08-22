import 'package:alataf/models/Products.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product_models.dart';

class DatabaseConfigHistory {
  Database? database;

  createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'history.db');

    database = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE products ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "product_id INTEGER,"
              "product_name TEXT,"
              "product_generic_name TEXT,"
              "product_category_name TEXT,"
              "product_price REAL,"
              "quantity INTEGER"
              ")");
        });
  }

  createCustomer(ProductItem product, int quantity) async {
    List list = await checkProductIfExist(product.id);
    print("history Existance check $list");
    if (list.isNotEmpty) {
      Map map = list[0];
      print("if exist ${map['product_name']}  ${map['quantity']}");
      updateProduct(product, (map['quantity'] + quantity));

    } else {
      var result = await database?.rawInsert(
          "INSERT INTO products (product_id, product_name, product_generic_name, product_category_name,product_price, quantity)"
              " VALUES (${product.id},"
              "'${product.productName}',"
              "'${product.genericName}', "
              "'${product.categoryName}',"
              "${product.price}, "
              "$quantity)");
      print(" history if first time $result qty $quantity");
      return result;
    }

    return null;

  }

  decrementAndUpdate(ProductItem product, int quantity) async {
    List list = await checkProductIfExist(product.id);
    print("Existance check $list");
    if (list != null) {
      Map map = list[0];
      print("if exist ${map['product_name']}  ${map['quantity']}");
      updateProduct(product, (map['quantity'] - 1));
    }
    return null;
  }

  Future<List> getProducts() async {
    print("prouct called");
    // var result = await database.query("products", columns: [
    //   "id",
    //   "product_id",
    //   "product_name",
    //   "product_generic_name",
    //   "product_category_name",
    //   "product_price",
    //   "quantity"
    // ]);
    var result = await database?.rawQuery("select * from products");
    print("result length-> ${result?.length}");
    print("product result-> $result");
    return result?.toList() ?? [];
  }

  Future<List> checkProductIfExist(int? id) async {
    var result = await database
        ?.rawQuery('SELECT * FROM products WHERE product_id = ${id ?? 0}');

    if ((result?.length ?? 0) > 0) {
      return result?.toList() ?? [];
    }

    return [];
  }

  Future<int> updateProduct(ProductItem note, int quantity) async {
    print("UPdate $quantity");
    return await database?.rawUpdate(
        'UPDATE products SET product_name = \'${note.productName}\', '
            'product_generic_name = \'${note.genericName}\', '
            'product_category_name = \'${note.categoryName}\', '
            'product_price = \'${note.price}\', '
            'quantity = \'$quantity\' '
            'WHERE product_id = ${note.id}') ??
        0;
  }

  Future<int> deleteProduct(int id) async =>
      await database
          ?.rawDelete('DELETE FROM products WHERE product_id = $id') ??
          0;

  Future<int> deleteAllProduct() async =>
      await database?.rawDelete('DELETE FROM products') ?? 0;

  Future<int> totalQuantity(String id) async {
    var result = await database
        ?.rawQuery('SELECT sum(quantity) FROM products WHERE product_id = $id');
    int total = result?[0] as int;
    return total;
  }

  dbClose() async {
    await database?.close();
  }
}
