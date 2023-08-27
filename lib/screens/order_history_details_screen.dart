import 'package:alataf/bloc/CartDetailsBloc.dart';
import 'package:alataf/bloc/OrderHistoryDetailsBloc.dart';
import 'package:alataf/bloc/ProductDetailsBloc.dart';
import 'package:alataf/main.dart';
import 'package:alataf/models/OrderCancelData.dart';
import 'package:alataf/models/OrderHistoryData.dart';
import 'package:alataf/screens/order_history_screen.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

class HistoryItemDetails extends StatefulWidget {
  @override
  HistoryItemDetailsState createState() {
    return HistoryItemDetailsState();
  }
}

class HistoryItemDetailsState extends State<HistoryItemDetails> {
  ProductDetailsBloc _productDetailsBloc = new ProductDetailsBloc();
  OrderHistoryDetailsBloc _orderHistoryDetailsBloc =
      new OrderHistoryDetailsBloc();
  int _itemCount = 0;
  var dateFormat = DateFormat("dd-MM-yyyy hh:mm:ss a")
      .format(DateTime.parse("2020-08-25 13:09:34"));
  static sliderImage(String item) {
    if (item.contains("http")) {
      print("Remote True");
      return Image.network(item, fit: BoxFit.cover, width: 1000.0);
    } else {
      print("Local True");
      return Image.asset(item);
    }
  }

  @override
  void initState() {
    super.initState();
    print("my date-> ${dateFormat}");
    _productDetailsBloc.streamCounter$.listen((onData) {
      print("Listen $onData");
      setState(() {
        try {
          _itemCount = onData;
        } catch (e) {}
      });
    });

    _orderHistoryDetailsBloc.streamResponseData$.listen((onData) {
      OrderCancelData data = onData as OrderCancelData;
      if (data != null) {
        if (data.success == "true") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (__) => OrderHistory()));
          Fluttertoast.showToast(
              msg: "Order has been canceled successfully",
              // duration: Toast.LENGTH_LONG,
              // gravity: Toast.CENTER,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white);
        }
      }
    });
  }

  @override
  void dispose() {
    getIt<CartDetailsBloc>().getProducts();
    _productDetailsBloc.dispose();
    _orderHistoryDetailsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Item product = ModalRoute.of(context)?.settings.arguments as Item;
    List<Widget> projectItems = product.orderDetails?.map((item) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
            child: Row(
              children: <Widget>[
                Text(item.productName ?? ""),
                SizedBox(width: 4),
                Text(item.strength ?? ""),
                Expanded(child: SizedBox()),
                Text("${item.quantity}"),
              ],
            ),
          );
        }).toList() ??
        [];

    var productList = Column(
      children: projectItems,
    );

    var prescriptionView = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // closeButton(context),
        Expanded(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              closeButton(context),
              SizedBox(height: 5),
              Text("ORDER DETAILS",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.calendarCheck,
                      size: 15,
                      color: Colors.grey[800],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        "Date: ${DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.parse("${product.createdAt}")).split(" ")[0]}",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.clock,
                      size: 15,
                      color: Colors.grey[800],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        "Time: ${DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.parse("${product.createdAt}")).split(" ")[1]} ${DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.parse("${product.createdAt}")).split(" ")[2]}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.check,
                      size: 15,
                      color: Colors.grey[800],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Text("Status: ${_getStatus(product.status)}", style: TextStyle(fontSize: 12,color: Colors.grey[700])),
                    _statusWidget(product.status),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text("Product Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              // Container(
              //   padding: EdgeInsets.only(left: 10, top: 5),
              //   alignment: Alignment.center,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Icon(
              //         Icons.my_location,
              //         size: 14,
              //         color: Colors.grey[700],
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Expanded(
              //           child: Text(product.address ?? "",
              //               style: TextStyle(
              //                   fontSize: 18, color: Colors.grey[600]))),
              //     ],
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 13),
              //   alignment: Alignment.center,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       FaIcon(
              //         FontAwesomeIcons.mobileAlt,
              //         size: 14,
              //         color: Colors.grey[700],
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Text("${product.phone}",
              //           style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 12, top: 10),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       FaIcon(
              //         FontAwesomeIcons.stickyNote,
              //         size: 14,
              //         color: Colors.grey[700],
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Text("Note: ${product.remarks}",
              //           style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 10),
              productList,
              // SizedBox(height: 8),
              Divider(
                height: 1,
                color: Colors.black54,
              ),
              // SizedBox(height: 8),
              Align(
                alignment: Alignment.topRight,
                child: Text("${product.totalAmount}/=",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              // SizedBox(height: 30),
              // SizedBox(height: 24),
              // Expanded(child: SizedBox()),
              // SizedBox(height: 24),
              Row(
                children: <Widget>[
                  // Expanded(child: SizedBox()),
                  // (product.status == 0)
                  //     ? buttonCancelOrder(context, product)
                  //     : SizedBox.shrink(),
                  // SizedBox(width: 16),
                  //buttonMessage(context, product),
                  //itemCounter(context),
                ],
              ),
              SizedBox(height: 30,),

              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                

                  child: Image.network(


                    "${product.prescriptionSrc}",
                    fit: BoxFit.cover,
                    height: 300,
                    width: double.infinity,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: spinKitChasingDots,
                      );
                    },
                  )),
              // SizedBox(height: 16),
            ],
          ),
        ),
        // SizedBox(height: 10),

        //pres

        SizedBox(height: 24),
        Row(
          children: <Widget>[
            Expanded(child: SizedBox()),

            StreamBuilder(
                stream: _orderHistoryDetailsBloc.streamLoader$,
                builder: (context, snapshot) {
                  return (snapshot.data)
                      ? spinCircleLoader
                      :
                      Container();

                  // buttonCancelOrder(context, product);
                }),

            SizedBox(width: 16),
            //buttonMessage(context, product),
            //itemCounter(context),
          ],
        ),
      ],
    );

    var productView = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        closeButton(context),
        SizedBox(height: 10),
        Text("ORDER DETAILS",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.calendarCheck,
                size: 15,
                color: Colors.grey[800],
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                  "Date: ${DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.parse("${product.createdAt}")).split(" ")[0]}",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.clock,
                size: 15,
                color: Colors.grey[800],
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                  "Time: ${DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.parse("${product.createdAt}")).split(" ")[1]} ${DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.parse("${product.createdAt}")).split(" ")[2]}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.check,
                size: 15,
                color: Colors.grey[800],
              ),
              SizedBox(
                width: 10,
              ),
              // Text("Status: ${_getStatus(product.status)}", style: TextStyle(fontSize: 12,color: Colors.grey[700])),
              _statusWidget(product.status),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text("Delivery Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Container(
          padding: EdgeInsets.only(left: 10, top: 5),
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.my_location,
                size: 14,
                color: Colors.grey[700],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(product.address ?? "",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]))),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 13),
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.mobileAlt,
                size: 14,
                color: Colors.grey[700],
              ),
              SizedBox(
                width: 10,
              ),
              Text("${product.phone}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.stickyNote,
                size: 14,
                color: Colors.grey[700],
              ),
              SizedBox(
                width: 10,
              ),
              Text("Note: ${product.remarks}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
        ),
        SizedBox(height: 40),
        productList,
        SizedBox(height: 8),
        Divider(
          height: 1,
          color: Colors.black54,
        ),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.topRight,
          child: Text("${product.totalAmount}/=",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 30),
        SizedBox(height: 24),
        Expanded(child: SizedBox()),
        SizedBox(height: 24),
        Row(
          children: <Widget>[
            Expanded(child: SizedBox()),
            (product.status == 0)
                ? Container()

            // buttonCancelOrder(context, product)
                : SizedBox.shrink(),
            SizedBox(width: 16),
            //buttonMessage(context, product),
            //itemCounter(context),
          ],
        ),
        SizedBox(height: 16),
      ],
    );

    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (__) => OrderHistory()));
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child:
                (product.prescription == "1") ? prescriptionView : productView),
      ),
    ));
  }

  Widget buttonMessage(BuildContext context, Item productItem) {
    return Column(
      children: <Widget>[
        Container(
          height: 42,
          child: ElevatedButton(
              onPressed: () {
                //_databaseConfig.createCustomer(productItem, _itemCount);
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
                "Re-Order",
                style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF)),
              )),
        ),
      ],
    );
  }

  // Widget buttonCancelOrder(BuildContext context, Item productItem) {
  //   return Column(
  //     children: <Widget>[
  //       Container(
  //         height: 42,
  //         child: ElevatedButton(
  //             onPressed: () {
  //               showAlertDialog(context, productItem.id.toString());
  //             },
  //             style: ElevatedButton.styleFrom(
  //               elevation: 8.0,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                   side: BorderSide(color: Color(0xFFF5926D))),
  //               backgroundColor: Color(0xFFF5926D),
  //             ),
  //             child: Text(
  //               "CANCEL ORDER",
  //               style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF)),
  //             )),
  //       ),
  //     ],
  //   );
  // }

  Widget itemCounter(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.white10,
          radius: 16,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.remove),
            color: Colors.black87,
            onPressed: () {
              _productDetailsBloc.decrement();
            },
          ),
        ),
        SizedBox(width: 16),
        StreamBuilder(
            stream: _productDetailsBloc.streamCounter$,
            builder: (context, snapshot) {
              return Container(
                padding: EdgeInsets.all(8.0),
                decoration: kBoxDecorationStyle,
                alignment: Alignment.center,
                width: 50,
                child: Text(
                  "${snapshot.data}",
                  style: TextStyle(fontSize: 30),
                ),
              );
            }),
        SizedBox(width: 16),
        CircleAvatar(
          backgroundColor: Colors.white10,
          radius: 16,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.add),
            color: Colors.black87,
            onPressed: () {
              _productDetailsBloc.increment();
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
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (__) => OrderHistory()));
            } else {
              SystemNavigator.pop();
            }
          },
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, productid) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(color: Colors.green[700]),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget yesButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(color: Colors.red[700]),
      ),
      onPressed: () {
        _orderHistoryDetailsBloc.orderCancelApi({'order_id': productid});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation Alert"),
      content: Text("Are you sure want to cancel this order?"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _statusWidget(value) {
    return Text(
      "Status: ${value == 0 ? "Pending" : value == 1 ? "Processing" : value == 2 ? "Ready to ship" : value == 3 ? "Shipped" : "Delivered"}",
      style: TextStyle(
          color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.bold),
    );
  }

  _launchUrl(value) async {
    if (await canLaunch("tel:$value")) {
      await launch("tel:$value");
    } else {
      throw 'Could not launch $value';
    }
  }
}
