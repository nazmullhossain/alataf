import 'package:flutter/material.dart';
import 'package:alataf/bloc/HistoryBloc.dart';
import 'package:alataf/models/CartItem.dart';
import 'package:alataf/models/OrderHistoryData.dart';
import 'package:alataf/screens/order_history_details_screen.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


import 'checkout_screen.dart';

class OrderHistory extends StatefulWidget {
  @override
  OrderHistoryState createState() {
    return OrderHistoryState();
  }
}

class OrderHistoryState extends State<OrderHistory> {
  HistoryBloc _historyBloc = HistoryBloc();

  @override
  void initState() {
    super.initState();
    Map orderParameter = {"order_id": 'all'};
    _historyBloc.callOrderHistoryApi(orderParameter);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Order History", style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 1.0,
            vertical: 16.0,
          ),
          child: StreamBuilder(
              stream: _historyBloc.streamOrderHistoryData$,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              List<Item> _item = snapshot.data as List<Item>;
                              return ListTile(
                                title: listItemView(_item[index]),
                              );
                            }),
                      ),
                      //proceedToCheckout(context, snapshot.data),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  );
                } else {
                  return StreamBuilder(
                      stream: _historyBloc.streamLoader$,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          if (!snapshot.data) {
                            return Container(
                              child: Center(child: Text("Order list is empty")),
                            );
                          } else {
                            return Center(child: spinCircleLoader);
                          }
                        } else
                          return Center(child: Text("No order yet"));
                      });
                }
              }),
        ),
      ),
    );
  }

  Widget listItemView(Item product) {
    String deliveryStatus = "Pending";
    if (product.status == 0) {
      deliveryStatus = "Pending";
    } else if (product.status == 1) {
      deliveryStatus = "Processing";
    } else if (product.status == 2) {
      deliveryStatus = "Ready to ship";
    } else if (product.status == 3) {
      deliveryStatus = "Shipped";
    } else if (product.status == 4) {
      deliveryStatus = "Delivered";
    } else {
      deliveryStatus = "Pending";
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HistoryItemDetails(),
                settings: RouteSettings(
                  arguments: product,
                )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.all(8.0),
        decoration: kBoxDecorationStyle,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Status: ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        deliveryStatus,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: (product.status == 0)
                              ? Colors.deepOrange
                              : (product.status == 4)
                                  ? Colors.green
                                  : Colors.blue,
                        ),
                      ),
                      // Expanded(child: SizedBox()),
                      // Text("${product.id}",
                      //     style: TextStyle(
                      //         fontSize: 15,
                      //         fontWeight: FontWeight.w700,
                      //         color: Colors.red)),
                    ],
                  ),
                  //Text("${product.orderDetails}", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Row(
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
                        "${DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.parse("${product.createdAt}")).split(" ")[0]}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
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
                          "${DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.parse("${product.createdAt}")).split(" ")[1]} ${DateFormat("dd-MM-yyyy hh:mm:ss a").format(DateTime.parse("${product.createdAt}")).split(" ")[2]}",
                          style:
                              TextStyle(fontSize: 11, color: Colors.black87)),
                    ],
                  ),
                ],
              ),
            ),
            //priceText(context, product),
            (product.prescription == "0")
                ? Text("BDT ${product.totalAmount}/=",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text("Rx"),
                      Icon(
                        LineAwesomeIcons.sticky_note,
                        size: 30,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget priceText(BuildContext context, CartItem product) {
    return Column(
      children: <Widget>[
        Text("BDT ${product.price}",
            style: TextStyle(fontSize: 16, color: Colors.deepOrange)),
      ],
    );
  }

  Widget proceedToCheckout(BuildContext context, List<Item> products) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 50,
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Checkout(),
                        settings: RouteSettings(
                          arguments: null,
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
                "Order History",
                style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF)),
              )),
        ),
      ],
    );
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
        onPressed: () {},
      ),
    );
  }

  Widget itemCounter(BuildContext context, CartItem product) {
    return Row(
      children: <Widget>[
        CircleAvatar(          radius: 16,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.remove),


            color: Colors.black54,
            onPressed: () {},
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
        SizedBox(width: 16),
        CircleAvatar(
          backgroundColor: Colors.white10,
          radius: 8,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.add),
            color: Colors.black54,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
