import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alataf/bloc/CartDetailsBloc.dart';
import 'package:alataf/bloc/Database.dart';
import 'package:alataf/bloc/ProductDetailsBloc.dart';
import 'package:alataf/main.dart';
import 'package:alataf/models/Products.dart';
import 'package:alataf/utilities/constants.dart';



class ProductDetails extends StatefulWidget {
  @override
  ProductDetailsState createState() {
    return ProductDetailsState();
  }
}

class ProductDetailsState extends State<ProductDetails> {
  ProductDetailsBloc _productDetailsBloc = new ProductDetailsBloc();
  DatabaseConfig? _databaseConfig;
  int _itemCount = 0;

  static sliderImage(String item) {
    if (item.contains("http")) {
      print("Remote True");
      return Image.network(item, fit: BoxFit.cover, width: 1000.0);
    } else {
      print("Local True");
      return Image.asset(item);
    }
  }

  double price = 0;

  @override
  void initState() {
    super.initState();
    _databaseConfig = DatabaseConfig();
    _databaseConfig?.createDatabase();
    _productDetailsBloc.streamCounter$.listen((onData) {
      print("Listen $onData");
//      setState(() {
      _itemCount = onData;
//      });
    });
  }

  @override
  void dispose() {
    //_databaseConfig.dbClose();
    getIt<CartDetailsBloc>().getProducts();
    _productDetailsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProductItem product =
        ModalRoute.of(context)?.settings.arguments as ProductItem;
    setState(() {
      price = double.parse("${product.price}");
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              closeButton(context),
              SizedBox(height: 16),
              Text(product.productName ?? "",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text(product.genericName ?? "",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(height: 20),
              Text("Company Name : ", style: TextStyle(fontSize: 14)),
              Text(product.companyName ?? "", style: TextStyle(fontSize: 18)),
              /*SizedBox(height: 16),
              Text("Manufacturer", style: TextStyle(fontSize: 14)),
              Text(product.categoryName, style: TextStyle(fontSize: 18)),*/
              SizedBox(height: 20),
              Text(product.categoryName ?? "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Text("BDT $price/=",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.center,
                          child: itemCounter(context)),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          buttonMessage(context, product),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonMessage(BuildContext context, ProductItem productItem) {
    return Container(
      height: 42,
      child: ElevatedButton(
          onPressed: () {
            _databaseConfig?.createCustomer(productItem, _itemCount);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              SystemNavigator.pop();
            }
          },
          style: ElevatedButton.styleFrom(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Color(0xFFF5926D))),
            backgroundColor: Color(0xFFF5926D),
          ),
          child: Text(
            "Add to Cart",
            style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF)),
          )),
    );
  }

  Widget itemCounter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 16,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.remove),
            color: Colors.black87,
            onPressed: () {
              _productDetailsBloc.decrement();
              setState(() {
                price = price * _productDetailsBloc.getCount();
                print("$price");
              });
            },
          ),
        ),
        SizedBox(width: 25),
        StreamBuilder(
            stream: _productDetailsBloc.streamCounter$,
            builder: (context, snapshot) {
              return Container(
                padding: EdgeInsets.all(8.0),
                decoration: kBoxDecorationStyle,
                alignment: Alignment.center,
                width: 60,
                height: 50,
                child: Text(
                  "${snapshot.data}",
                  style: TextStyle(fontSize: 30),
                ),
              );
            }),
        SizedBox(width: 25),
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 16,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.add),
            color: Colors.black87,
            onPressed: () {
              _productDetailsBloc.increment();
              setState(() {
                price = price * _productDetailsBloc.getCount();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget closeButton(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: CircleAvatar(
        backgroundColor: Colors.black12,
        radius: 20,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.close),
          color: Colors.black87,
          onPressed: () {
            //databaseConfig.getProducts();
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              SystemNavigator.pop();
            }
          },
        ),
      ),
    );
  }
}
