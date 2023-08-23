import 'package:flutter/material.dart';
import 'package:alataf/models/CartItem.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'checkout_screen.dart';

class Message extends StatefulWidget {
  @override
  MessageState createState() {
    return MessageState();
  }
}

class MessageState extends State<Message> {


  final String facebookMessengerUrl = "http://m.me/alatafpharma";

  void _openMessenger() async {
    // Check if the Facebook Messenger app is installed
    if (await canLaunch(facebookMessengerUrl)) {
      // If the app is installed, open it
      await launch(facebookMessengerUrl);
    } else {
      // If the app is not installed, open the web version of Messenger
      final webMessengerUrl = "https://www.facebook.com/alatafpharma";
      await launch(webMessengerUrl);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Messages", style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          // child: StreamBuilder(
          //     stream: null,
          //     builder: (context, snapshot) {
          //       if (snapshot.data != null) {
          //         return Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: <Widget>[
          //             Expanded(
          //               child: ListView.builder(
          //                   shrinkWrap: true,
          //                   itemCount: snapshot.data == null ? 0 : 0,
          //                   itemBuilder: (context, index) {
          //                     return ListTile(
          //                       title: listItemView(snapshot.data[index]),
          //                     );
          //                   }),
          //             ),
          //             proceedToCheckout(context, snapshot.data),
          //             SizedBox(
          //               height: 8,
          //             )
          //           ],
          //         );
          //       } else {
          //         return Container(
          //           child: Center(child: Text("Message list is empty")),
          //         );
          //       }
          //     }),
        ),
        
        floatingActionButton: FloatingActionButton(

          elevation: 10,

          onPressed: (){

          _openMessenger();

        },child: Icon(Icons.message,),),
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
          Text(product.genericName ?? "", style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          Text(product.categoryName ?? "", style: TextStyle(fontSize: 14)),
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

  Widget priceText(BuildContext context, CartItem product) {
    return Column(
      children: <Widget>[
        Text("BDT ${product.price}",
            style: TextStyle(fontSize: 16, color: Colors.deepOrange)),
      ],
    );
  }

  Widget proceedToCheckout(BuildContext context, List<CartItem> products) {
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
        CircleAvatar(
          backgroundColor: Colors.white10,
          radius: 16,
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
