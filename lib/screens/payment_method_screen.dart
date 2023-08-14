import 'package:alataf/bloc/PaymentMethodBloc.dart';
import 'package:alataf/screens/order_complete_screen.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final spinLoader = SpinKitCircle(
  color: Colors.orange,
  size: 50.0,
);

class PaymentMethod extends StatefulWidget {
  @override
  PaymentMethodState createState() {
    return PaymentMethodState();
  }
}

class PaymentMethodState extends State<PaymentMethod> {
  PaymentMethodBloc _paymentMethodBloc = PaymentMethodBloc();

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
    Future.delayed(Duration.zero, _orderCreatedResponseListener);
  }

  void _orderCreatedResponseListener() {
    _paymentMethodBloc.streamConfirmResponse$.listen((data) {
      print(data.runtimeType);
      if (data.success == "true") {
        WidgetsBinding.instance.addPostFrameCallback((_) =>
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderComplete(),
                    settings: RouteSettings(arguments: data))));
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) =>
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderComplete(),
                    settings: RouteSettings(arguments: data))));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map itemDetails = ModalRoute.of(context)?.settings.arguments as Map;
    print("phone number-> ${itemDetails["phone"]}");
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: 50.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              closeButton(context),
              SizedBox(height: 16),
              Text("Select Payment Method",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Row(
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: 1,
                    onChanged: null,
                  ),
                  SizedBox(width: 4),
                  Text("Cash on Delivery", style: TextStyle(fontSize: 18))
                ],
              ),
              Expanded(child: SizedBox()),
              Text(
                  "You can pay in cash to our courier when you receive the goods at your doorstep",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
              SizedBox(height: 24),
              StreamBuilder(
                  stream: _paymentMethodBloc.streamLoader$,
                  builder: (context, snapshot) {
                    if (snapshot.data == false) {
                      return buttonConfirmOrder(context, itemDetails);
                    } else {
                      return Center(
                        child: spinLoader,
                      );
                    }
                  }),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonConfirmOrder(BuildContext context, Map itemDetails) {
    return Column(
      children: <Widget>[
        Container(
          height: 42,
          child: ElevatedButton(
              onPressed: () {
                print(itemDetails);
                print(itemDetails['product_id']);
                _showConfirmAlert(context, itemDetails);
              },
              style: ElevatedButton.styleFrom(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xFFF5926D))),
                backgroundColor: Color(0xFFF5926D),
              ),
              child: Text(
                "CONFIRM ORDER",
                style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF)),
              )),
        ),
      ],
    );
  }

  _showConfirmAlert(context, itemDetails) {
    Widget noButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        "No",
        style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
      ),
    );

    Widget yesButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
        _paymentMethodBloc.callAPI(itemDetails);
      },
      child: Text(
        "Yes",
        style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
      ),
    );

    var dialog = AlertDialog(
      title: Text(
        "Order Confirmation",
        style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
      ),
      content: Text("Are you sure want to confirm this order?"),
      actions: [noButton, yesButton],
    );
    showDialog(
        context: context,
        builder: (context) {
          return dialog;
        });
  }
}

Widget itemCounter(BuildContext context) {
  return Row(
    children: <Widget>[
      Text(
        "-",
        style: TextStyle(fontSize: 80),
      ),
      SizedBox(width: 16),
      Container(
        decoration: kBoxDecorationStyle,
        alignment: Alignment.center,
        width: 50,
        child: Text(
          "0",
          style: TextStyle(fontSize: 30),
        ),
      ),
      SizedBox(width: 16),
      Text(
        "+",
        style: TextStyle(fontSize: 50),
      ),
    ],
  );
}

Widget closeButton(BuildContext context) {
  return Container(
    alignment: Alignment.topRight,
    child: CircleAvatar(
      backgroundColor: Colors.black12,
      radius: 16,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.close,
          size: 20,
          color: Colors.black54,
        ),
        color: Colors.black87,
        onPressed: () {
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
