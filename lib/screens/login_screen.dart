import 'dart:convert';
import 'dart:io' show Platform;

import 'package:alataf/screens/registration_phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:alataf/bloc/LoginBloc.dart';
import 'package:alataf/models/LoginData.dart';
import 'package:alataf/screens/registration_screen.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:url_launcher/url_launcher.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  LoginBloc _loginBloc = new LoginBloc();
  bool _rememberMe = false;
  String _email = "";
  String _password = "";
  String? _contactText;
  GoogleSignInAccount? _currentUser;

  void login() async {
    var loginCredential = {
      'phone': "${selectedValue}${_email}",
      'password': _password,
    };
    //----- comment by rasel
    _loginBloc.callAPI(loginCredential, isWholeSale: false);
  }

  void _loginResponseListener() {
    _loginBloc.streamResponseData$.listen((data) {
      print(data.runtimeType);
      if (data.success == "true") {
        Navigator.pop(context);
        Fluttertoast.showToast(msg:"Login success");
        // Fluttertoast.showToast(msg: "Login success");
        /*WidgetsBinding.instance
            .addPostFrameCallback((_) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                )));*/
      } else {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _showDialog(context, data));
      }
    });
  }

  _launchURL() async {
    const url = 'http://128.199.195.219/customer_forgot';
    if (await launchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _handleGetContact() async {
    print("contact getting");
    setState(() {
      _contactText = "Loading contact info...";
    });
    await http
        .get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await _currentUser?.authHeaders,
    )
        .then((response) {
      if (response.statusCode != 200) {
        setState(() {
          _contactText = "People API gave a ${response.statusCode} "
              "response. Check logs for details.";
        });
        print('People API ${response.statusCode} response: ${response.body}');
        return;
      }
      final Map<String, dynamic> data = json.decode(response.body);
      final String? namedContact = _pickFirstNamedContact(data);
      setState(() {
        if (namedContact != null) {
          _contactText = "I see you know $namedContact!";
        } else {
          _contactText = "No contacts to display.";
        }
      });
    });

    print("contact info-> $_contactText");
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact.isNotEmpty) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name.isNotEmpty) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  List<String> dropDownItems = ['+88', '+96'];
  String selectedValue = "+88";

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loginResponseListener);

    _googleSignIn.onCurrentUserChanged.listen((account) {
      print("Now in google response");
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        LoginData loginData = LoginData();
        loginData.email = _currentUser?.email ?? "";
        loginData.customerName = _currentUser?.displayName ?? "";
        _handleGetContact();
        print("I am here");
        WidgetsBinding.instance.addPostFrameCallback(
              (_) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RegistrationScreen("", "", "", "", "", "", "", "", 0),
              settings: RouteSettings(
                arguments: loginData,
              ),
            ),
          ),
        );

        _handleSignOut();
        // _handleGetContact();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loginView();
  }

  Widget loginView() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0, systemOverlayStyle: SystemUiOverlayStyle.dark, // status bar brightness
      ),
      body: Form(
        key: _formKey,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        _buildEmailTF(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildPasswordTF(),
                        _buildForgotPasswordBtn(),
                        _buildLoginBtn(),
                        // _buildSignInWithText(),
                        // _buildSocialBtnRow(),
                        _buildSignUpBtn(context),
                        //_buildBody()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            ///------------ phone prefis
            Expanded(
              child: Container(
                height: 65,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: kBoxDecorationStyle,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    // decoration: InputDecoration(
                    //   border: InputBorder.none,
                    // ),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value ?? "+88";
                      });
                      print("$value");
                    },
                    alignment: Alignment.center,
                    value: selectedValue,
                    items: dropDownItems
                        .map((e) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: e,
                        child: Text(
                          e,
                          textAlign: TextAlign.center,
                        )))
                        .toList(),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),

            ///--------- phone field
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
                alignment: Alignment.centerLeft,
                decoration: kBoxDecorationStyle,
                child: TextFormField(
                  onChanged: (text) {
                    _email = text;
                  },
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.black87,
                    ),
                    hintText: 'Enter your Phone',
                    hintStyle: kHintTextStyle,
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a valid phone';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
          decoration: kBoxDecorationStyle,
          child: TextFormField(
              onChanged: (text) {
                _password = text;
              },
              obscureText: true,
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black87,
                ),
                hintText: 'Enter your Password',
                hintStyle: kHintTextStyle,
              ),
              validator: (value) {
                if (value!.length < 6) {
                  return 'Required at least 6 character';
                }
                if (value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              }),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => _launchURL(),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25.0),
      padding: EdgeInsets.all(15.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            login();
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Color(0xFFF5926D),
        ),
        child: StreamBuilder(
            stream: _loginBloc.streamLoader$,
            builder: (context, snapshot) {
              if (snapshot.data != null && snapshot.data) {
                return spinDoubleBounceLoader;
              } else {
                return Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                );
              }
            }),
      ),
    );
  }

  // Widget _buildSignInWithText() {
  //   return Column(
  //     children: <Widget>[
  //       Text(
  //         '- OR -',
  //         style: TextStyle(
  //           color: Colors.grey,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildSocialBtn(Function onTap, AssetImage logo) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Row(
  //       children: <Widget>[
  //         Container(
  //           height: 54.0,
  //           width: 54.0,
  //           padding: EdgeInsets.all(10.0),
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: Colors.white,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black26,
  //                 offset: Offset(0, 2),
  //                 blurRadius: 6.0,
  //               ),
  //             ],
  //             image: DecorationImage(
  //               image: logo,
  //             ),
  //           ),
  //         ),
  //         SizedBox(width: Platform.isIOS ? 15 : 8),
  //         Platform.isIOS
  //             ? Container(
  //                 height: 54.0,
  //                 width: 54.0,
  //                 alignment: Alignment.center,
  //                 padding: EdgeInsets.all(10.0),
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   color: Colors.white,
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black26,
  //                       offset: Offset(0, 2),
  //                       blurRadius: 6.0,
  //                     ),
  //                   ],
  //                 ),
  //                 child: FaIcon(FontAwesomeIcons.apple))
  //             : Text(
  //                 "SIGNUP WITH GOOGLE",
  //                 style: TextStyle(fontWeight: FontWeight.normal),
  //               )
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildSocialBtnRow() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 20.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         /*_buildSocialBtn(
  //           () => showToast(),
  //           AssetImage(
  //             'assets/logos/facebook.jpg',
  //           ),
  //         ),*/
  //         _buildSocialBtn(
  //           () => _handleSignIn(),
  //           // () {},
  //           AssetImage(
  //             'assets/logos/google.png',
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  howToast() {
    Fluttertoast.showToast(msg:"Something went wrong",
        // duration: Toast.LENGTH_SHORT,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white);
    // return Fluttertoast.showToast(
    //   textColor: Colors.white,
    //   backgroundColor: Colors.redAccent,
    //   msg: "Something went wrong",
    //   toastLength: Toast.LENGTH_SHORT,
    // );
  }

  Widget _buildSignUpBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationPhone(),
                    ),
                    // MaterialPageRoute(
                    //   builder: (context) =>
                    //       RegistrationScreen("", "", "", "", "", "", "", "", 0),
                    // ),
                  );
                },
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, LoginData loginData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
              height: 200.0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      LineAwesomeIcons.exclamation_triangle,
                      color: Colors.deepOrangeAccent,
                      size: 50.0,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Login Failed",
                      style: TextStyle(fontSize: 24, color: Colors.deepOrange),
                    ),
                    SizedBox(height: 16),
                    Text("Sorry, unrecognized email or password"),
                  ],
                ),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text("CLOSE"),
              onPressed: () {
                Navigator.of(context).pop();
                //Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
