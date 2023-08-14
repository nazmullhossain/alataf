import 'package:alataf/models/LoginData.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingAddress extends StatefulWidget {
  @override
  ShippingAddressState createState() {
    return ShippingAddressState();
  }
}

class ShippingAddressState extends State<ShippingAddress> {
  var _textAddressController = TextEditingController();
  var _textMobileNumberController = TextEditingController();
  var _textEmailController = TextEditingController();
  var _textShopNameController = TextEditingController();
  var _textNotesController = TextEditingController();

  static sliderImage(String item) {
    if (item.contains("http")) {
      print("Remote True");
      return Image.network(item, fit: BoxFit.cover, width: 1000.0);
    } else {
      print("Local True");
      return Image.asset(item);
    }
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

  @override
  void initState() {
    super.initState();
    initPref();
  }

  @override
  Widget build(BuildContext context) {
    final LoginData userData =
        ModalRoute.of(context)?.settings.arguments as LoginData;
    _textAddressController.text = userData.address ?? "";
    _textMobileNumberController.text = userData.phone ?? "";
    _textEmailController.text = userData.email ?? "";
    _textNotesController.text = userData.remarks ?? "";
    _textShopNameController.text = userData.shopName ?? "";
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              closeButton(context),
              SizedBox(height: 16),
              Text("Add Shipping & Billing Address",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text("Name",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                alignment: Alignment.center,
                decoration: kBoxDecorationStyle,
                child: TextFormField(
                  controller: TextEditingController()
                    ..text = userData.customerName ?? "",
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.supervised_user_circle,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your name',
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
              if (isWholeSale) SizedBox(height: 16),
              if (isWholeSale)
                Text("Shop Name",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              if (isWholeSale)
                Container(
                  margin: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                  alignment: Alignment.center,
                  decoration: kBoxDecorationStyle,
                  child: TextFormField(
                    controller: _textShopNameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.house,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter your shop name',
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
              SizedBox(height: 16),
              Text("Shipping Address",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                alignment: Alignment.center,
                decoration: kBoxDecorationStyle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _textAddressController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.my_location,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter your full address',
                      hintStyle: kHintTextStyle,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter full address';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text("Mobile Number",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                alignment: Alignment.center,
                decoration: kBoxDecorationStyle,
                child: TextFormField(
                  controller: _textMobileNumberController,
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.phone_iphone,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your mobile number',
                    hintStyle: kHintTextStyle,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter mobile number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Text("Email Address",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                alignment: Alignment.center,
                decoration: kBoxDecorationStyle,
                child: TextFormField(
                  controller: _textEmailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your email address',
                    hintStyle: kHintTextStyle,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter email address';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Text("Notes",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                alignment: Alignment.center,
                decoration: kBoxDecorationStyle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _textNotesController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.note,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter notes',
                      hintStyle: kHintTextStyle,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter some notes here';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
              buttonConfirmOrder(context),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonConfirmOrder(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 42,
          alignment: Alignment.center,
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'address': _textAddressController.text,
                  'phone': _textMobileNumberController.text,
                  'email': _textEmailController.text,
                  "remarks": _textNotesController.text,
                  "shop-name": _textShopNameController.text,
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xFFF5926D))),
                backgroundColor: Color(0xFFF5926D),
                elevation: 8.0,
              ),
              child: Text(
                "SAVE",
                style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF)),
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
