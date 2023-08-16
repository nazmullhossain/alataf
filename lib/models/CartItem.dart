import 'package:alataf/models/Products.dart';
import 'package:alataf/models/product_models.dart';

class CartItem extends ProductItem {
  int? quantity;
  CartItem({this.quantity});
}
