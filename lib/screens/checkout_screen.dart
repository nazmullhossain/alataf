import 'package:alataf/bloc/CheckoutBloc.dart';
import 'package:alataf/models/LoginData.dart';
import 'package:alataf/screens/payment_method_screen.dart';
import 'package:alataf/screens/shipping_address_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  @override
  CheckoutState createState() {
    return CheckoutState();
  }
}

class CheckoutState extends State<Checkout> {
  CheckoutBloc _checkoutBloc = CheckoutBloc();
  @override
  void initState() {
    super.initState();
    initPref();
    _checkoutBloc.getUserPreference();
  }

  bool isWholeSale = false;

  initPref() async {
    await SharedPreferences.getInstance().then((value) {
      setState(() {
        isWholeSale = value.getBool("is_owner") ?? false;
        print("is whole sale -> ${isWholeSale}");
      });
    });
  }

  void _showProfileUpdateDialog(
      BuildContext context, loginData, orderReadyItem) {
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
                    Text("Update required",
                        style: TextStyle(fontSize: 24, color: Colors.red)),
                    SizedBox(height: 20),
                    Text(
                        "To checkout please update your shipping & billing address",
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
                  "Edit Shipping & Billing",
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShippingAddress(),
                          settings: RouteSettings(
                            arguments: loginData,
                          )));
                  loginData.address = result['address'];
                  loginData.phone = result['phone'];
                  loginData.email = result['email'];
                  loginData.remarks = result['remarks'];
                  loginData.shopName = result['shop-name'];
                  orderReadyItem['address'] = loginData.address;
                  orderReadyItem['remarks'] = result['remarks'];
                  orderReadyItem['shop_name'] = result['shop_name'];
                  print("order items-> ${orderReadyItem["remarks"]}");
                  print("cp -> remarks -> ${result['remarks']}");
                  await _checkoutBloc.updateUserPreference(loginData);
                  Navigator.of(context).pop();
                },
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map orderReadyItem =
        ModalRoute.of(context)?.settings.arguments as Map;
    String notes;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          child: StreamBuilder(
              stream: _checkoutBloc.streamUserPreferenceData$,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  LoginData loginData = snapshot.data;
                  print("my address-> ${snapshot.data}");
                  orderReadyItem['address'] = loginData.address;
                  orderReadyItem['key'] = loginData.key;
                  orderReadyItem['phone'] = loginData.phone;
                  orderReadyItem['remarks'] =
                      loginData.remarks == null ? "" : loginData.remarks;
                  orderReadyItem['shop_name'] = loginData.shopName ?? "";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      closeButton(context),
                      SizedBox(height: 16),
                      Text("Shipping & Billing",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(loginData.customerName ?? "",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),

                      ///--------------------- [shop name] ----------------------------
                      // SizedBox(height: 8),
                      // Text(loginData.shopName ?? "",
                      //     style: TextStyle(
                      //         fontSize: 14, fontWeight: FontWeight.normal)),

                      // ///--------------------- [trade license] ----------------------------
                      // Text(loginData.tradeLicence ?? "",
                      //     style: TextStyle(
                      //         fontSize: 14, fontWeight: FontWeight.normal)),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Text("Shipping Address"),
                          Expanded(child: SizedBox()),
                          GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShippingAddress(),
                                        settings: RouteSettings(
                                          arguments: loginData,
                                        )));
                                loginData.address = result['address'];
                                loginData.phone = result['phone'];
                                loginData.email = result['email'];
                                loginData.remarks = result['remarks'];
                                loginData.shopName = result['shop-name'];
                                orderReadyItem['address'] = loginData.address;
                                orderReadyItem['remarks'] = result['remarks'];
                                orderReadyItem['shop_name'] =
                                    result['shop_name'];
                                print(
                                    "order items-> ${orderReadyItem["remarks"]}");
                                print("cp -> remarks -> ${result['remarks']}");
                                await _checkoutBloc
                                    .updateUserPreference(loginData);
                              },
                              child: Text(
                                "EDIT",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              ))
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade400,
                                  offset: Offset(0, 2),
                                  blurRadius: 6,
                                  spreadRadius: 0.0)
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   width: double.infinity,
                            //   padding: EdgeInsets.all(4.0),
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //         width: 1, style: BorderStyle.solid),
                            //   ),
                            //   child: Text(
                            //     loginData.address,
                            //     style: TextStyle(
                            //         fontSize: 18,
                            //         fontWeight: FontWeight.normal,
                            //         color: Colors.blueAccent),
                            //   ),
                            // ),
                            Row(
                              children: [
                                Icon(
                                  Icons.my_location,
                                  color: Colors.grey[700],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  loginData.address ?? "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: Colors.blueAccent),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Text("\u{1F4DE} ${loginData.phone}",
                                style: TextStyle(fontSize: 14)),
                            SizedBox(height: 5),
                            Text("\u{1F4E7} ${loginData.email}",
                                style: TextStyle(fontSize: 14)),
                            if (isWholeSale) SizedBox(height: 8),
                            if (isWholeSale)
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.hospitalUser,
                                    size: 10,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(loginData.shopName ?? "",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            if (isWholeSale)
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.list,
                                    size: 10,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),

                                  ///--------------------- [trade license] ----------------------------
                                  Text(loginData.tradeLicence ?? "",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.note,
                                  color: Colors.grey[700],
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                    "Notes: ${loginData.remarks == null ? "" : loginData.remarks}",
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Text("Order Summary",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Text("Subtotal", style: TextStyle(fontSize: 16)),
                          Expanded(child: SizedBox()),
                          Text("Tk ", style: TextStyle(fontSize: 12)),
                          Text(
                              "${double.parse(orderReadyItem['total_amount'].toString()).toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Text("Shipping fee", style: TextStyle(fontSize: 15)),
                          Expanded(child: SizedBox()),
                          Text("Tk ", style: TextStyle(fontSize: 12)),
                          Text("50", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Text("Total",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          Expanded(child: SizedBox()),
                          Text("Tk ", style: TextStyle(fontSize: 12)),
                          Text(
                              "${double.parse((orderReadyItem['total_amount'] + 50).toString()).toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      proceedToPayment(context, orderReadyItem, loginData),
                    ],
                  );
                } else {
                  return SpinKitRotatingCircle(
                    color: Colors.black26,
                    size: 20.0,
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget proceedToPayment(BuildContext context, Map itemDetails, loginData) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 50,
          child: ElevatedButton(
              onPressed: () async {
                print("my data-> ${itemDetails["remarks"]}");
                await SharedPreferences.getInstance().then((value) {
                  if ((value.getBool("is_owner") ?? false) &&
                      (itemDetails['shop_name'] ?? "") == "") {
                    _showProfileUpdateDialog(context, loginData, itemDetails);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentMethod(),
                            settings: RouteSettings(arguments: itemDetails)));
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xFFF5926D))),
                backgroundColor: Color(0xFFF5926D),
              ),
              child: Text(
                "PROCEED TO PAYMENT",
                style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF)),
              )),
        ),
      ],
    );
  }
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
