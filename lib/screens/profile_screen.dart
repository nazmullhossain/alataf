import 'package:alataf/bloc/ProfilesBloc.dart';
import 'package:alataf/models/LoginData.dart';
import 'package:alataf/models/ProfilesData.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:toast/toast.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  int _radioValue = 0;
  int _result = 0;

  bool checkout = false;

  bool isWholeSale = false;

  ProfilesBloc _profilesBloc2 = ProfilesBloc();
  final _formKey = GlobalKey<FormState>();
  var _textNameController = TextEditingController();
  var _textAddressController = TextEditingController();
  var _textMobileNumberController = TextEditingController();
  var _textEmailController = TextEditingController();
  var _textPostCodeController = TextEditingController();
  var _textCityController = TextEditingController();
  var _textShopNameController = TextEditingController();
  var _textTradeLicenceController = TextEditingController();

  _handleRadioValueChange(int? value) {
    print(value);
    setState(() {
      _radioValue = value ?? 0;
      switch (_radioValue) {
        case 0:
          _result = 0;
          break;
        case 1:
          _result = 1;
          break;
        case 2:
          _result = 2;
          break;
      }
    });
  }

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
    _profilesBloc2.getUserPreference();
    _profilesBloc2.streamUserPreferenceData$.listen((data) {
      LoginData loginData = data as LoginData;
      _textNameController.text = loginData.customerName ?? "";
      _textEmailController.text =
          loginData.email == null || loginData.email == "null"
              ? ""
              : loginData.email!;
      _textAddressController.text =
          loginData.address == null || loginData.address == "null"
              ? ""
              : loginData.address!;
      _textMobileNumberController.text = loginData.phone ?? "";
      _textPostCodeController.text = loginData.postcode.toString();
      _textCityController.text = loginData.city ?? "";
      _radioValue = loginData.gender ?? 0;
      _textTradeLicenceController.text = loginData.tradeLicence ?? "";
      _textShopNameController.text = loginData.shopName ?? "";
    });

    _profilesBloc2.streamUpdateResultData$.listen((data) {
      ProfilesData loginData = data as ProfilesData;
      if (loginData.success == "true") {
        Fluttertoast.showToast(msg:loginData.message.toString(),
            // duration: Toast.LENGTH_SHORT,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.green,
            textColor: Colors.white);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Current Radion $_radioValue");
    // Build a Form widget using the _formKey created above.
    checkout = (ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>?)?['checkout'] ??
        false;
    print("checkout -> $checkout and whole -> ${isWholeSale}");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: StreamBuilder(
                stream: _profilesBloc2.streamUserPreferenceData$,
                builder: (context, snapshot) {
                  LoginData loginData = snapshot.data as LoginData;
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          decoration: kBoxDecorationStyle,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _textNameController,
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
                                if (value == '') {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          alignment: Alignment.center,
                          decoration: kBoxDecorationStyle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _textEmailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.mail_outline,
                                  color: Colors.grey,
                                ),
                                hintText: 'Enter your Email',
                                hintStyle: kHintTextStyle,
                              ),
                              validator: (value) {
                                if (value == '') {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          alignment: Alignment.center,
                          decoration: kBoxDecorationStyle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _textAddressController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.home,
                                  color: Colors.grey,
                                ),
                                hintText: 'Enter your address',
                                hintStyle: kHintTextStyle,
                              ),
                              validator: (value) {
                                if (value == '') {
                                  return 'Please enter your address';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          alignment: Alignment.center,
                          decoration: kBoxDecorationStyle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _textMobileNumberController,
                              enabled: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.grey,
                                ),
                                hintText: 'Enter your mobile number',
                                hintStyle: kHintTextStyle,
                              ),
                              validator: (value) {
                                if (value == '') {
                                  return 'Please enter your mobile number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        // SizedBox(height: 8),
                        // Container(
                        //   alignment: Alignment.center,
                        //   decoration: kBoxDecorationStyle,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: TextFormField(
                        //       controller: _textCityController,
                        //       decoration: InputDecoration(
                        //         border: InputBorder.none,
                        //         prefixIcon: Icon(
                        //           Icons.location_city,
                        //           color: Colors.grey,
                        //         ),
                        //         hintText: 'Enter your city',
                        //         hintStyle: kHintTextStyle,
                        //       ),
                        //       validator: (value) {
                        //         if (value == '') {
                        //           return 'Please enter your city name';
                        //         }
                        //         return null;
                        //       },
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 8),
                        // Container(
                        //   alignment: Alignment.center,
                        //   decoration: kBoxDecorationStyle,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: TextFormField(
                        //       controller: _textPostCodeController,
                        //       decoration: InputDecoration(
                        //         border: InputBorder.none,
                        //         prefixIcon: Icon(
                        //           Icons.local_post_office,
                        //           color: Colors.grey,
                        //         ),
                        //         hintText: 'Enter your Postcode',
                        //         hintStyle: kHintTextStyle,
                        //       ),
                        //       validator: (value) {
                        //         if (value == '') {
                        //           return 'Please enter your postcode';
                        //         }
                        //         return null;
                        //       },
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 8),
                        // Row(
                        //   children: <Widget>[
                        //     Text("Gender"),
                        //     Radio(
                        //       value: 1,
                        //       groupValue: _radioValue,
                        //       onChanged: _handleRadioValueChange,
                        //     ),
                        //     Text("Male"),
                        //     SizedBox(width: 24),
                        //     Radio(
                        //       value: 2,
                        //       groupValue: _radioValue,
                        //       onChanged: _handleRadioValueChange,
                        //     ),
                        //     Text("Female")
                        //   ],
                        // ),

                        isWholeSale ? SizedBox(height: 8) : Container(),
                        isWholeSale
                            ? Container(
                                alignment: Alignment.center,
                                decoration: kBoxDecorationStyle,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _textShopNameController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.my_location,
                                        color: Colors.grey,
                                      ),
                                      hintText: 'Enter your shop name',
                                      hintStyle: kHintTextStyle,
                                    ),
                                    validator: (value) {
                                      if (value == '') {
                                        return 'Please enter your shop name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              )
                            : Container(),

                        isWholeSale ? SizedBox(height: 8) : Container(),
                        isWholeSale
                            ? Container(
                                alignment: Alignment.center,
                                decoration: kBoxDecorationStyle,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _textTradeLicenceController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.local_post_office,
                                        color: Colors.grey,
                                      ),
                                      hintText: 'Enter your trade licence',
                                      hintStyle: kHintTextStyle,
                                    ),
                                    validator: (value) {
                                      if (value == '') {
                                        return 'Please enter your trade licence';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 12,
                        ),
                        StreamBuilder(
                            stream: _profilesBloc2.streamLoader$,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data == true) {
                                return Center(child: spinCircleLoader);
                              } else {
                                return buttonConfirmOrder(context, loginData);
                              }
                            }),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget buttonConfirmOrder(BuildContext context, LoginData loginData) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Map<String, dynamic> profiles = {
                  "name": _textNameController.text,
                  "mobile": _textMobileNumberController.text,
                  // "gender": _radioValue.toString(),
                  "address": _textAddressController.text,
                  // "postcode": _textPostCodeController.text,
                  // "city": _textCityController.text,
                  "email": _textEmailController.text,
                  if (isWholeSale) "shop_name": _textShopNameController.text,
                  if (isWholeSale)
                    "trade_license": _textTradeLicenceController.text,
                  "key": loginData.key
                };
                _profilesBloc2.callAPI(
                    profiles,
                    context,
                    checkout,
                    (ModalRoute.of(context)?.settings.arguments
                            as Map<String, dynamic>?)?['item'] ??
                        null);
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
              "UPDATE",
              style: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
            ),
          ),
        )
      ],
    );
  }
}
