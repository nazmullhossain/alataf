import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// final apiURL = "http://128.199.195.219/api/";

 const  apiURL = "http://139.59.119.57/api/";

final kHintTextStyle = TextStyle(
  color: Color(0xFF999999),
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.grey,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFFF5F5F5),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final buttonBoxDecorationStyle = BoxDecoration(
  color: Color(0xFFF5926D),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black45,
      blurRadius: 9.0,
      offset: Offset(0, 2),
    ),
  ],
);

commonAppbar(text) => AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Text(
        text,
        style: TextStyle(color: Colors.black87),
      ),
    );

final spinDoubleBounceLoader = SpinKitDoubleBounce(
  color: Colors.white,
  size: 20.0,
);

final spinCircleLoader = SpinKitCircle(
  color: Colors.deepOrange,
  size: 30.0,
);

final spinKitChasingDots = SpinKitFadingFour(
  color: Colors.deepOrange,
  size: 40.0,
);

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension MobileNumberValidator on String {
  bool isValidMobileNumber() {
    return RegExp(r'(^([+]{1}[8]{2}|0088|88)?(01){1}[3-9]{1}\d{8})$')
        .hasMatch(this);
  }
}
