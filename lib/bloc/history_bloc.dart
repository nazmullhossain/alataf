import 'package:alataf/bloc/Database.dart';
import 'package:alataf/models/CartItem.dart';
import 'package:alataf/models/Products.dart';
import 'package:rxdart/rxdart.dart';

import '../models/product_models.dart';
import 'history_database_bloc.dart';

class HistoryDetailsBloc {
  BehaviorSubject _counter = new BehaviorSubject<int>.seeded(0);
  BehaviorSubject _product = new BehaviorSubject<List<CartItem>>.seeded([]);

  Stream get streamCounter$ => _counter.stream;

  Stream get streamProducts$ => _product.stream;
  DatabaseConfigHistory? databaseConfig;

  initDatabase() async {
    databaseConfig = new DatabaseConfigHistory();
    await databaseConfig?.createDatabase();
  }

  getProducts() async {
    List<CartItem> productList = [];
    List list = await databaseConfig?.getProducts() ?? [];
    for (Map map in list) {
      CartItem productItem = CartItem();
      productItem.productName = map['product_name'];
      productItem.categoryName = map['product_category_name'];
      productItem.genericName = map['product_generic_name'];
      productItem.price = map['product_price'];
      productItem.id = map['product_id'];
      productItem.quantity = map['quantity'];
      productList.add(productItem);
      print("All from database ${map['product_name']}");
    }
    _product.add(productList);
  }

  deleteProduct(int productId) async {
    int result = await databaseConfig?.deleteProduct(productId) ?? 0;
    if (result == 1) {
      getProducts();
    }
  }

  deleteAllProduct() async {
    int result = await databaseConfig?.deleteAllProduct() ?? 0;
    if (result == 1) {
      getProducts();
    }
  }

  incrementAndUpdate(ProductItem cartItem, int quantity) async {
    ProductItem productItem = cartItem;
    await databaseConfig?.createCustomer(productItem, 1);
    await getProducts();
    print(productItem.productName);
  }

  increment() {
    _counter.add(_counter.value + 1);
  }

  decrementAndUpdate(ProductItem cartItem, int quantity) async {
    ProductItem productItem = cartItem;
    await databaseConfig?.decrementAndUpdate(productItem, 1);
    await getProducts();
    print(productItem.productName);
  }

  double getTotalPrice(var data) {
    List<CartItem> cartItems = [];
    cartItems = data as List<CartItem>;
    double totalPrice = 0;
    for (CartItem item in cartItems) {
      totalPrice += (item.price * item.quantity);
    }
    return totalPrice;
  }

  Map getItemDetailsForMakingOrder(var data) {
    List<CartItem> cartItems = [];
    cartItems = data as List<CartItem>;
    String qtyList = "";
    String productIdList = "";
    double totalPrice = 0;
    for (CartItem item in cartItems) {
      qtyList += "${item.quantity},,";
      productIdList += "${item.id},,";
      totalPrice += (item.price * item.quantity);
    }

    Map orderReadyItem = {
      'product_id': productIdList,
      'quantity': qtyList,
      'total_amount': totalPrice,
      'ref_no': "",
      'discount': 0,
      'remarks': "",
      'address': "",
      'tran_id': 0,
      'key': ""
    };
    return orderReadyItem;
  }

  startLoading() {
    _counter.add(true);
  }

  stopLoading() {
    _counter.add(false);
  }

  dispose() {
    _counter.value = 0;
    _counter.close();
    print("Dispose called from bloc");
  }
}
