import 'package:alataf/bloc/RegistrationBloc.dart';
import 'package:alataf/models/LoginData.dart';
import 'package:alataf/models/RegistrationData.dart';
import 'package:alataf/screens/cart_details_screen.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:toast/toast.dart';

import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  String name;
  String email;
  String phone;
  String address;
  String city;
  String postCode;
  String password;
  String confirmPassword;
  int gender;
  RegistrationScreen(this.name, this.email, this.phone, this.address, this.city,
      this.postCode, this.password, this.confirmPassword, this.gender);
  @override
  RegistrationScreenState createState() {
    return RegistrationScreenState(
        this.name,
        this.email,
        this.phone,
        this.address,
        this.city,
        this.postCode,
        this.password,
        this.confirmPassword,
        this.gender);
  }
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiCallService = new RegistrationBloc();
  FocusNode textFocusNode = FocusNode();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  int _radioValue = 0;

  //getting values
  String name;
  String email;
  String phone;
  String address;
  String city;
  String postCode;
  String password;
  String confirmPassword;
  int gender;
  RegistrationScreenState(
      this.name,
      this.email,
      this.phone,
      this.address,
      this.city,
      this.postCode,
      this.password,
      this.confirmPassword,
      this.gender);
  //end of gettings value

  String _fullName = "";
  String _email = "";
  String _phone = "";
  String _address = "";
  String _city = "";
  String _postCode = "";
  String _password = "";
  String _confirmPassword = "";
  String _shopOwnerName = "";
  String _shopOwnerAddress = "";
  String _shopOwnerTradeLicense = "";

  bool _obscuredPasswordText = true;
  bool _obscuredTextConfirmPassword = true;

  var _textNameController = TextEditingController();
  var _textEmailController = TextEditingController();
  var _textPhoneController = TextEditingController();
  var _textAddressController = TextEditingController();
  var _textCityController = TextEditingController();
  var _textPostCodeController = TextEditingController();
  var _textPasswordController = TextEditingController();
  var _textConfirmPasswordController = TextEditingController();
  bool isButtonPressed = false;

  _toggle() {
    setState(() {
      _obscuredPasswordText = !_obscuredPasswordText;
    });
  }

  _toggle2() {
    setState(() {
      _obscuredTextConfirmPassword = !_obscuredTextConfirmPassword;
    });
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  bool isChecked = false;

  void _onShopOwnerCheckBoxChanged(bool? newValue) => setState(() {
        isChecked = newValue ?? false;

        if (isChecked) {
          // TODO: Here goes your functionality that remembers the user.
        } else {
          // TODO: Forget the user
        }
      });

  _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    textFocusNode = FocusNode();
    _textNameController.text = name;
    _textEmailController.text = email;
    _textPhoneController.text = phone;
    _textAddressController.text = address;
    _textCityController.text = city;
    _textPostCodeController.text = postCode;
    _textPasswordController.text = password;
    _textConfirmPasswordController.text = confirmPassword;
    _radioValue = gender;
    _fullName = name;
    _email = email;
    _phone = phone;
    _address = address;
    _city = city;
    _postCode = postCode;
    _password = password;
    _confirmPassword = confirmPassword;
  }

  @override
  void dispose() {
    super.dispose();
    _apiCallService.dispose();
    textFocusNode.dispose();
  }

  gotoScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartDetails(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // final LoginData? socialLoginData =
    //     ModalRoute.of(context)?.settings.arguments as LoginData;
    // if (socialLoginData != null) {
    //   _textNameController.text = socialLoginData.customerName ?? "";
    //   _textEmailController.text = socialLoginData.email ?? "";
    //   _email = _textEmailController.text;
    //   _fullName = _textNameController.text;
    // }

    return SafeArea(
      child: StreamBuilder(
          stream: _apiCallService.streamResponseData$,
          builder: (context, snapshot) {
            RegistrationData? re = snapshot.data;
            if (re == null) {
              return registrationView();
            } else if (re.success == "false") {
              print("registration -> in false");

              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _showDialog(context, re));
              return registrationView();
            } else {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _showDialogSuccess(context));
              return registrationView();
            }
          }),
    );
  }

  void showWarningToast(String message) {
    Fluttertoast.showToast(msg:message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        backgroundColor: Colors.red,
        // duration: Toast.LENGTH_SHORT,
        // gravity: Toast.BOTTOM


    );
  }

  Widget textFieldFullName(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _textNameController,
          onChanged: (text) {
            setState(() {
              _fullName = text;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              LineAwesomeIcons.user,
              color: Colors.black87,
            ),
            hintText: 'Enter your full name',
            hintStyle: kHintTextStyle,
          ),
          validator: (value) {
            if (value == null) {
              showWarningToast('Please enter your full name');
              return 'Please enter your full name';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget textFieldEmail(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _textEmailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (text) {
            _email = text;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black87,
            ),
            hintText: 'Enter your Email',
            hintStyle: kHintTextStyle,
          ),
          validator: (value) {
            if (!(value?.isValidEmail() ?? false)) {
              showWarningToast('Enter a valid email address');
              return 'Enter a valid email address';
            }
            if (value == null) {
              showWarningToast('Please enter your email');
              return 'Please enter your email';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget textFieldPhoneNumber(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _textPhoneController,
          focusNode: textFocusNode,
          keyboardType: TextInputType.phone,
          enabled: false,
          readOnly: true,
          onChanged: (text) {
            _phone = text;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.black87,
            ),
            hintText: 'Enter your phone number',
            hintStyle: kHintTextStyle,
          ),
          // validator: (value) {
          //   if (!value!.isValidMobileNumber()) {
          //     textFocusNode.requestFocus();
          //     showWarningToast('Enter a valid mobile number');
          //     return 'Enter a valid mobile number';
          //   }

          //   if (value.isEmpty) {
          //     showWarningToast('Enter a valid mobile number');
          //     return 'Enter a valid mobile number';
          //   }
          //   return null;
          // },
        ),
      ),
    );
  }

  Widget textFieldAddress(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _textAddressController,
          onChanged: (text) {
            _address = text;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.home,
              color: Colors.black87,
            ),
            hintText: 'Enter your address',
            hintStyle: kHintTextStyle,
          ),
          validator: (value) {
            if (value == null) {
              showWarningToast('Please enter your address');
              return 'Please enter your address';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget textFieldCity(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _textCityController,
          onChanged: (text) {
            _city = text;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.location_city,
              color: Colors.black87,
            ),
            hintText: 'Enter your city',
            hintStyle: kHintTextStyle,
          ),
          validator: (value) {
            if (value == null) {
              showWarningToast('Please enter your city');
              return 'Please enter your city';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget textFieldPostCode(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _textPostCodeController,
          keyboardType: TextInputType.number,
          onChanged: (text) {
            _postCode = text;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.place,
              color: Colors.black87,
            ),
            hintText: 'Enter your postcode',
            hintStyle: kHintTextStyle,
          ),
          validator: (value) {
            if (value == null) {
              showWarningToast('Please enter your post code');
              return 'Please enter your post code';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget textFieldPassword(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          obscureText: _obscuredPasswordText,
          controller: _textPasswordController,
          onChanged: (text) {
            setState(() {
              _password = text;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: TextButton(
                onPressed: _toggle,
                child: Icon(Icons.remove_red_eye,
                    color: _obscuredPasswordText
                        ? Colors.black12
                        : Colors.black54)),
            prefixIcon: Icon(
              Icons.vpn_key,
              color: Colors.black87,
            ),
            hintText: 'Enter your Password',
            hintStyle: kHintTextStyle,
          ),
          validator: (value) {
            if (value == null) {
              showWarningToast('Please enter password');
              return 'Please enter password';
            }
            if (value.length < 6) {
              showWarningToast('At least 6 character required');
              return 'At least 6 character required';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget textFieldConfirmPassword(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _textConfirmPasswordController,
          obscureText: _obscuredTextConfirmPassword,
          onChanged: (text) {
            setState(() {
              _confirmPassword = text;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: TextButton(
                onPressed: _toggle2,
                child: Icon(Icons.remove_red_eye,
                    color: _obscuredTextConfirmPassword
                        ? Colors.black12
                        : Colors.black54)),
            prefixIcon: Icon(
              Icons.vpn_key,
              color: Colors.black87,
            ),
            hintText: 'Confirm your password',
            hintStyle: kHintTextStyle,
          ),
          validator: (value) {
            if (value == null) {
              showWarningToast('Please confirm your password');
              return 'Please confirm your password';
            }
            if (_password != _confirmPassword) {
              showWarningToast('Confirm password does not match');
              return 'Password does not match';
            }

            return null;
          },
        ),
      ),
    );
  }

  Widget shopOwnerView(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // SizedBox(height: 16),
          // textShopOwnerName(context),
          // SizedBox(height: 16),
          // textShopOwnerAddress(context),
          SizedBox(height: 16),
          textShopOwnerTradeLicense(context)
        ],
      ),
    );
  }

  Widget textShopOwnerName(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          onChanged: (text) {
            setState(() {
              _shopOwnerName = text;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              LineAwesomeIcons.user,
              color: Colors.black87,
            ),
            hintText: 'Enter shop owner name',
            hintStyle: kHintTextStyle,
          ),
          validator: (value) {
            if (value==null && isChecked) {
              return 'Field can not be blank';
            }
            if (value!.length < 10) {
              showWarningToast('At least 6 character required');
              return 'At least 6 character required';
            }

            return null;
          },
        ),
      ),
    );
  }

  Widget textShopOwnerAddress(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          onChanged: (text) {
            setState(() {
              _shopOwnerAddress = text;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              LineAwesomeIcons.home,
              color: Colors.black87,
            ),
            hintText: 'Enter shop owner address',
            hintStyle: kHintTextStyle,
          ),
          validator: (value) {
            if (value == null) {
              return 'Shop owner address can not be blank';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget textShopOwnerTradeLicense(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          onChanged: (text) {
            setState(() {
              _shopOwnerTradeLicense = text;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.library_books,
              color: Colors.black87,
            ),
            hintText: 'Enter shop owner trade license',
            hintStyle: kHintTextStyle,
          ),
          validator: (value) {
            if (value == null) {
              return 'Please enter you trade licence';
            }
            // if (_password != _shopOwnerName) {
            //   return 'Password does not match';
            // }

            return null;
          },
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, RegistrationData regData) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Container(
              height: 200.0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.do_not_disturb,
                      color: Colors.deepOrangeAccent,
                      size: 50.0,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Registration Failed",
                      style: TextStyle(fontSize: 24, color: Colors.deepOrange),
                    ),
                    SizedBox(height: 16),
                    Text(regData.message?.email?[0] ?? ""),
                    SizedBox(height: 4),
                    Text(regData.message?.mobile?[0] ?? ""),
                  ],
                ),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text("CLOSE"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (__) => RegistrationScreen(
                            _fullName,
                            _email,
                            _phone,
                            _address,
                            _city,
                            _postCode,
                            _password,
                            _confirmPassword,
                            _radioValue)));
                //Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogSuccess(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            content: Container(
                height: 160.0,
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.done_outline,
                      color: Colors.lightGreen,
                      size: 50.0,
                    ),
                    SizedBox(height: 16),
                    Text("Success",
                        style:
                            TextStyle(fontSize: 24, color: Colors.lightGreen)),
                    SizedBox(height: 20),
                    Text("Your account has been created",
                        style:
                            TextStyle(fontSize: 18, color: Colors.grey[600])),
                  ],
                )),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text(
                  "OK",
                  style: TextStyle(color: Colors.black87, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ));
                  //Navigator.pop(context);
                },
              ),
            ]);
      },
    );
  }

  Widget registrationView() {
    return Scaffold(
      appBar: commonAppbar("Registration"),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                textFieldFullName(context),
                // SizedBox(height: 16),
                // textFieldEmail(context),
                SizedBox(height: 16),
                textFieldPhoneNumber(context),
                // SizedBox(height: 16),
                // textFieldAddress(context),
                // SizedBox(height: 16),
                // textFieldCity(context),
                // SizedBox(height: 16),
                // textFieldPostCode(context),
                SizedBox(height: 16),
                textFieldPassword(context),
                SizedBox(height: 16),
                textFieldConfirmPassword(context),
                // Row(
                //   children: <Widget>[
                //     Text(
                //       "Gender",
                //       style: TextStyle(fontSize: 16),
                //     ),
                //     SizedBox(width: 24),
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
                CheckboxListTile(
                  dense: true,
                  title: Text(
                    "Tick if shop owner",
                    style: TextStyle(fontSize: 18),
                  ),
                  value: isChecked,
                  onChanged: _onShopOwnerCheckBoxChanged,
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                Container(
                    child:
                        isChecked ? shopOwnerView(context) : SizedBox.shrink()),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Color(0xFFF5926D),
                    ),
                    onPressed: () {
                      print("tap ${_formKey.currentState!.validate()}");
                      if (_formKey.currentState!.validate()) {
                        registration();
                      }
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        width: double.maxFinite,
                        child: StreamBuilder(
                            stream: _apiCallService.streamLoader$,
                            builder: (context, snapshot) {
                              print("snapshot data -> $snapshot");
                              if (snapshot.data != null && snapshot.data) {
                                if (!snapshot.hasData) {
                                  return Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  );
                                } else {
                                  return spinDoubleBounceLoader;
                                }
                              } else {
                                return Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                            })),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registration() {
    Map<String, String> registerUserData = {
      'name': _fullName,
      // 'email': _email,
      'mobile': _phone,
      // 'address': _address,
      // 'city': _city,
      // 'postcode': _postCode,
      'password': _password,
      'password_confirmation': _confirmPassword,
      // 'gender': "$_radioValue",
      'app_version': "${_packageInfo.version}",
      // 'shop_owner_name': _shopOwnerName,
      // 'shop_owner_address': _shopOwnerAddress,
      'trade_license': _shopOwnerTradeLicense,
      // 'national_id_card': "",
    };
    _apiCallService.callAPI(registerUserData, isWholeSale: isChecked);
  }
}
