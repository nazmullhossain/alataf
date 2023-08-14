import 'dart:convert';

import 'package:alataf/bloc/CartDetailsBloc.dart';
import 'package:alataf/bloc/MainBloc.dart';
import 'package:alataf/main.dart';
import 'package:alataf/models/CartItem.dart';
import 'package:alataf/screens/checkout_screen.dart';
import 'package:alataf/screens/login_screen.dart';
import 'package:alataf/screens/profile_screen.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartDetails extends StatefulWidget {
  @override
  CartDetailsState createState() {
    return CartDetailsState();
  }
}

class CartDetailsState extends State<CartDetails> {
  CartDetailsBloc? _cartDetailsBloc;

  @override
  void initState() {
    super.initState();
    _cartDetailsBloc = getIt<CartDetailsBloc>();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(const Duration(milliseconds: 100), () {
              _cartDetailsBloc?.getProducts();
            }));
  }

  @override
  void dispose() {
    _cartDetailsBloc?.getProducts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              "Cart",
              style: TextStyle(color: Colors.black),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0.0,
            backgroundColor: Colors.white),
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          child: StreamBuilder(
              stream: _cartDetailsBloc?.streamProducts$,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: listItemView(snapshot.data[index]),
                              );
                            }),
                      ),
                      proceedToCheckout(context, snapshot.data),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  );
                } else {
                  return Container(
                    child: Center(child: Text("Cart is empty")),
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget proceedToCheckout(BuildContext context, List<CartItem> products) {
    if (products.length > 0) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 50,
            child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  bool isWholeSale = prefs.getBool("is_owner") ?? false;
                  String userData = prefs.getString('user_key_value') == null ||
                          prefs.getString('user_key_value') == ''
                      ? '{"email":"null", "address":"null"}'
                      : prefs.getString('user_key_value')!;
                  print("data -> ${prefs.getString('user_key_value')}");
                  Map<String, dynamic> data = jsonDecode("${userData}");
                  print("User data => ${userData}");
                  if (getIt<MainBloc>().key.toString().trim().length == 0) {
                    _showLoginConfirmDialog(context);
                    return;
                  } else if ("${data["email"]}" == "null" ||
                      "${data['address']}" == "null") {
                    _showProfileUpdateDialog(context, products);
                    return;
                  } else if (isWholeSale &&
                      ("${data['shop_name']}" == "null" ||
                          "${data['trade_license']}" == "null")) {
                    _showProfileUpdateDialog(context, products);
                    return;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Checkout(),
                          settings: RouteSettings(
                            arguments: _cartDetailsBloc!
                                .getItemDetailsForMakingOrder(products),
                          )));
                },
                style: ElevatedButton.styleFrom(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Color(0xFFF5926D))),
                  backgroundColor: Color(0xFFF5926D),
                ),
                child: Text(
                  "PROCEED TO CHECKOUT (BDT ${_cartDetailsBloc?.getTotalPrice(products).toStringAsFixed(2)})",
                  style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF)),
                )),
          ),
        ],
      );
    } else {
      return Expanded(
        child: Center(
          child: Text(""
              "Cart is empty"),
        ),
      );
    }
  }

  Widget closeButton(BuildContext context, int productId) {
    return CircleAvatar(
      backgroundColor: Colors.black12,
      radius: 16,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.delete,
          size: 20,
          color: Colors.black54,
        ),
        color: Colors.black87,
        onPressed: () {
          _showConfirmDialog(context, productId);
        },
      ),
    );
  }

  Widget listItemView(CartItem product) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(product.productName ?? "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              Expanded(child: SizedBox()),
              closeButton(context, product.id ?? 0),
            ],
          ),
          Text(product.genericName ?? '', style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          Text(product.categoryName ?? '', style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              priceText(context, product),
              Expanded(child: SizedBox()),
              itemCounter(context, product),
            ],
          ),
          SizedBox(height: 4),
          Divider(
            color: Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget itemCounter(BuildContext context, CartItem product) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.white10,
          radius: 16,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.remove),
            color: Colors.black54,
            onPressed: () {
              if ((product.quantity ?? 0) > 1) {
                _cartDetailsBloc?.decrementAndUpdate(product, 1);
              } else {
                return null;
              }
            },
          ),
        ),
        SizedBox(width: 8),
        Container(
          decoration: kBoxDecorationStyle,
          alignment: Alignment.center,
          width: 50,
          child: Text(
            "${product.quantity}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Colors.white10,
          radius: 16,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.add),
            color: Colors.black54,
            onPressed: () {
              _cartDetailsBloc?.incrementAndUpdate(product, 1);
            },
          ),
        ),
      ],
    );
  }

  void _showConfirmDialog(BuildContext context, int productId) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            content: Container(
                height: 150.0,
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 50.0,
                    ),
                    SizedBox(height: 8),
                    Text("Delete",
                        style: TextStyle(fontSize: 24, color: Colors.red)),
                    SizedBox(height: 20),
                    Text("Are you sure want to delete now?",
                        style: TextStyle(fontSize: 18, color: Colors.black87)),
                  ],
                )),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text(
                  "NO",
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  //Navigator.pop(context);
                },
              ),
              new TextButton(
                child: new Text(
                  "YES",
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _cartDetailsBloc?.deleteProduct(productId);
                  //Navigator.pop(context);
                },
              ),
            ]);
      },
    );
  }

  void _showLoginConfirmDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            content: Container(
                height: 150.0,
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.perm_device_information,
                      color: Colors.red,
                      size: 50.0,
                    ),
                    SizedBox(height: 8),
                    Text("Login required",
                        style: TextStyle(fontSize: 24, color: Colors.red)),
                    SizedBox(height: 20),
                    Text("To checkout please login first.",
                        style: TextStyle(fontSize: 18, color: Colors.black87)),
                  ],
                )),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                  //Navigator.pop(context);
                },
              ),
            ]);
      },
    );
  }

  void _showProfileUpdateDialog(BuildContext context, products) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            content: Container(
                height: 150.0,
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.perm_device_information,
                      color: Colors.red,
                      size: 50.0,
                    ),
                    SizedBox(height: 8),
                    Text("Profile update required",
                        style: TextStyle(fontSize: 24, color: Colors.red)),
                    SizedBox(height: 20),
                    Text("To checkout please update your profile",
                        style: TextStyle(fontSize: 18, color: Colors.black87)),
                  ],
                )),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(),
                          settings: RouteSettings(arguments: {
                            "checkout": true,
                            "item": _cartDetailsBloc!
                                .getItemDetailsForMakingOrder(products),
                          })));
                  //Navigator.pop(context);
                },
              ),
            ]);
      },
    );
  }
}

Widget priceText(BuildContext context, CartItem product) {
  return Column(
    children: <Widget>[
      Text("BDT ${product.price}",
          style: TextStyle(fontSize: 16, color: Colors.deepOrange)),
    ],
  );
}
