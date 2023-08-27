import 'dart:convert';

import 'package:alataf/bloc/CartDetailsBloc.dart';
import 'package:alataf/bloc/SearchBloc.dart';
import 'package:alataf/main.dart';
import 'package:alataf/models/CartItem.dart';
import 'package:alataf/models/Products.dart';
import 'package:alataf/screens/cart_details_screen.dart';
import 'package:alataf/screens/product_details_screen.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../bloc/hitory_database.dart';
import '../provider/imge_provider.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() {
    return SearchState();
  }
}

final _apiCallService = new SearchBloc();

class SearchState extends State<Search> with WidgetsBindingObserver {
  static sliderImage(String item) {
    if (item.contains("http")) {
      print("Remote True");
      return Image.network(item, fit: BoxFit.cover, width: 1000.0);
    } else {
      print("Local True");
      return Image.asset(item);
    }
  }



  int getTotalItemQuantity(var data) {
    List<CartItem> cartItems = [];
    cartItems = data as List<CartItem>;
    int totalItem = 0;
    for (CartItem item in cartItems) {
      totalItem += item.quantity ?? 0;
    }
    return totalItem;
  }

  int getTotalItem(var data) {
    List<CartItem> items = [];
    items = data as List<CartItem>;
    return items.length;
  }

  //save data share preference

  // // Define a function to save the data.
  // Future<void> saveProductData(String productName, double price, String categoryName, String companyName) async {
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   prefs.setString('productName', productName);
  //   prefs.setDouble('price', price);
  //   prefs.setString('setString', categoryName);
  //   prefs.setString('companyName', companyName);
  // }
  //
  //
  // Future<void> _saveData(ProductItem userList) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String jsonString = jsonEncode(userList);
  //   prefs.setString('userList', jsonString );
  // }

  Future<void> saveData(List<Map<String, dynamic>> dataList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(dataList);
    await prefs.setString('dataList', jsonData);
  }



  void saveDataToSharedPreferences(List<Map<String, dynamic>> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('data_key', jsonEncode(data));
  }




  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getIt<CartDetailsBloc>().getProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    _apiCallService.stopLoading();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Row(
              children: <Widget>[
                Expanded(child: SizedBox()),
                StreamBuilder(
                    stream: getIt<CartDetailsBloc>().streamProducts$,
                    builder: (context, snapshot) {
                      int totalItemCount = 0;
                      if (snapshot.data != null)
                        totalItemCount = getTotalItem(snapshot.data);
                      return GestureDetector(
                          onTap: () {
                            if (totalItemCount == 0) {
                              Fluttertoast.showToast(
                                  msg: "Cart is empty",
                                  // gravity: Toast.TOP,
                                  // duration: Toast.LENGTH_SHORT,

                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: Colors.deepOrangeAccent,
                                  textColor: Colors.white);
                              // Fluttertoast.showToast(
                              //     textColor: Colors.white,
                              //     backgroundColor: Colors.deepOrangeAccent,
                              //     msg: "Cart is empty",
                              //     toastLength: Toast.LENGTH_SHORT,
                              //     gravity: ToastGravity.TOP);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CartDetails(),
                                  ));
                            }
                          },
                          child: badges.Badge(
                            showBadge: (totalItemCount == 0) ? false : true,
                            badgeContent: Text(
                              "$totalItemCount",
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Icon(Icons.shopping_basket),
                          ));
                    })
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0.0,
            backgroundColor: Colors.white),
        drawer: Drawer(),
        backgroundColor: Color(0xFFFFFFFF),
        body: Consumer<RecipeClass>(

          builder: (BuildContext context, provider, Widget? child) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 2.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  searchView(),
                  SizedBox(height: 20),
                  StreamBuilder(
                      stream: _apiCallService.streamLoader$,
                      builder: (context, snapshot) {
                        print("snap data-> ${snapshot.data}");
                        if (snapshot.data != null) {
                          if (snapshot.data) {
                            return Center(child: spinLoader);
                          } else {
                            return Container();
                          }
                        } else
                          return Container();
                      }),
                  SizedBox(height: 2),
                  StreamBuilder(
                      stream: _apiCallService.streamProducts$,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    (snapshot.data as List<ProductItem>).length,
                                itemBuilder: (context, index) {
                                  var data =
                                      (snapshot.data as List<ProductItem>)[index];
                                  return ListTile(
                                    onTap: () async{

                                      await DbHelper.dbHelper.insertNewRecipe(data);

                                      provider.getRecipes();





                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetails(),
                                              settings: RouteSettings(
                                                arguments: data,
                                              )));
                                    },
                                    title: listItem(context, data),
                                  );
                                }),
                          );
                        } else {
                          return defaultSearchView(context);
                        }
                      }),
                ],
              ),
            );
          }
        ),
      ),

    );
  }

  Widget defaultSearchView(BuildContext context) {
    return Expanded(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.search,
            size: 30,
            color: Colors.black26,
          ),
          SizedBox(height: 4),
          Text("Search your medicine here",
              style: TextStyle(color: Colors.black54)),
        ],
      )),
    );
  }
}

Widget listItem(BuildContext context, ProductItem productItem) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(productItem.productName ?? "",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(productItem.genericName ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 14, color: Colors.black87)),
            SizedBox(width: 4),
            Flexible(
              child: Text(productItem.strength ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            textViewCategory(context, productItem.categoryName ?? ""),
            Expanded(child: SizedBox()),
            textViewPrice(context, productItem.price),
          ],
        ),
        SizedBox(height: 4),
        Divider(color: Colors.grey),
        SizedBox(
          height: 1,
        )
      ],
    ),
  );
}

final spinLoader = SpinKitRotatingCircle(
  color: Colors.black26,
  size: 20.0,
);

Widget searchView() {
  return Consumer<RecipeClass>(
    builder: (context, provider, child) {
      return Container(
        alignment: Alignment.center,
        decoration: kBoxDecorationStyle,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: TextFormField(

            autofocus: true,
            onChanged: (text) {
              _apiCallService.getInfo(text);
              print("First text field: $text");
            },
            onEditingComplete: () {

            },
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              hintText: 'Search generic/brand name',
              hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
      );
    }
  );
}

Widget textViewCategory(BuildContext context, String categoryName) {
  return Column(
    children: <Widget>[
      Text(categoryName, style: TextStyle(fontSize: 18, color: Colors.black54)),
    ],
  );
}

Widget textViewPrice(BuildContext context, dynamic price) {
  return Row(
    children: <Widget>[
      Text(
        "Tk",
        style: TextStyle(fontSize: 16, color: Colors.black26),
      ),
      SizedBox(width: 2),
      Text(
        "$price",
        style: TextStyle(fontSize: 24, color: Colors.black54),
      ),
    ],
  );
}

Widget closeButton(BuildContext context) {
  return Container(
    alignment: Alignment.topRight,
    child: TextButton(
      onPressed: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Icon(
        Icons.close,
        size: 35,
        color: Colors.grey,
      ),
    ),
  );
}
