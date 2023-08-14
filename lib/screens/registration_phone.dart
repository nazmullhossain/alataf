import 'package:alataf/screens/registration_phone_verific.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../utilities/constants.dart';

class RegistrationPhone extends StatefulWidget {
  const RegistrationPhone({super.key});

  @override
  State<RegistrationPhone> createState() => _RegistrationPhoneState();
}

class _RegistrationPhoneState extends State<RegistrationPhone> {
  final _formKey = GlobalKey<FormState>();
  List<String> dropDownItems = ['+88', '+96'];
  String selectedValue = "+88";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController phoneController = TextEditingController();
  bool requestingForOtp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: commonAppbar(""),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          child: Form(
            key: _formKey,
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Phone Verificaton",
                style: TextStyle(
                  color: Color(0xFFF5926D),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your phone number to \nget otp verification",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                children: [
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
                              selectedValue = value ?? "+880";
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
                  Expanded(flex: 3, child: phoneNumber(context)),
                ],
              ),
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
                  onPressed: requestingForOtp
                      ? () {}
                      : () async {
                    setState(() {
                      requestingForOtp = true;
                    });
                    String phone = phoneController.text.toString();

                    if (phone.length < 11) {
                      print("hello click");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Enter your phone number"),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red.shade400,
                        ),
                      );
                    } else {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '${selectedValue}${phone}',
                        verificationCompleted:
                            (PhoneAuthCredential credential)async {
                              // await FirebaseAuth.instance.signInWithCredential(credential);
                              // requestingForOtp = true;
                            },
                        verificationFailed: (FirebaseAuthException e) {
                          setState(() {
                            requestingForOtp = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Phone verification failed, Please try again"),
                              backgroundColor: Colors.red.shade400,
                            ),
                          );
                        },
                        codeSent:
                            (String verificationId, int? resendToken) {
                          setState(() {
                            requestingForOtp = false;
                          });


                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegistrationPhoneVerification(),
                                settings: RouteSettings(arguments: {
                                  'phone_code': selectedValue,
                                  'phone_number': phone,
                                  'token': resendToken,
                                  'id': verificationId
                                })),
                          );
                        },
                        codeAutoRetrievalTimeout:
                            (String verificationId) {
                          setState(() {
                            requestingForOtp = false;
                          });
                          // Navigator.of(context).pop();
                          print("timeout -> $verificationId");
                        },
                      );
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      width: double.maxFinite,
                      child: requestingForOtp
                          ? spinDoubleBounceLoader
                          : Text(
                        'Send OTP',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget phoneNumber(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          onChanged: (text) {
            setState(() {});
          },
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              LineAwesomeIcons.phone,
              color: Colors.black87,
            ),
            hintText: 'Enter your phone number',
            hintStyle: kHintTextStyle,
          ),
          validator: (value) {
            if (value == null && (value?.length ?? 0) < 11) {
              return 'Enter your phone number';
            }

            return null;
          },
        ),
      ),
    );
  }
}
