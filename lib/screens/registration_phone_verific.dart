import 'package:alataf/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../utilities/constants.dart';

class RegistrationPhoneVerification extends StatefulWidget {
  const RegistrationPhoneVerification({super.key});

  @override
  State<RegistrationPhoneVerification> createState() =>
      _RegistrationPhoneVerificationState();
}

class _RegistrationPhoneVerificationState
    extends State<RegistrationPhoneVerification> {
  TextEditingController pinController = TextEditingController();
  late Map<String, dynamic> data;
  @override
  void initState() {
    super.initState();
  }

  bool otpVerifying = false;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        appBar: commonAppbar(""),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Phone Verificaton",
                style: TextStyle(
                  color: Color(0xFFF5926D),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "We sent 6 digit otp to \n${data['phone_code']}${data['phone_number']} number",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 35,
              ),
              pinField(),
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
                  onPressed: otpVerifying
                      ? () {}
                      : () async {
                          setState(() {
                            otpVerifying = true;
                          });
                          try {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            // Create a PhoneAuthCredential with the code
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: data['id'],
                                    smsCode: pinController.text);

                            // Sign the user in (or link) with the credential
                            await auth
                                .signInWithCredential(credential)
                                .then((value) {
                              print("ret value -> $value");
                              if (value.additionalUserInfo != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistrationScreen(
                                        "",
                                        "",
                                        "${data['phone_code']}${data['phone_number']}",
                                        "",
                                        "",
                                        "",
                                        "",
                                        "",
                                        0),
                                  ),
                                );
                              }
                            });
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              otpVerifying = false;
                            });
                            print("err -> ${e.code}");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(e.message ?? ''),
                              backgroundColor: Colors.red.shade400,
                            ));

                            if (e.code != 'invalid-verification-code') {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      width: double.maxFinite,
                      child: otpVerifying
                          ? spinDoubleBounceLoader
                          : Text(
                              'Verify OTP',
                              style: TextStyle(color: Colors.white),
                            )),
                ),
              ),
            ],
          ),
        ));
  }

  String otp = '';
  pinField() => PinCodeTextField(
        appContext: context,
        length: 6,
        textStyle: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,

        animationType: AnimationType.fade,
        // backgroundColor: Colors.white,
        obscureText: false,
        controller: pinController,
        onChanged: (value) {
          print("on change -> $value");
        },
        autoFocus: true,
        enableActiveFill: true,
        pinTheme: PinTheme(
          borderRadius: BorderRadius.circular(10),
          shape: PinCodeFieldShape.box,
          errorBorderColor: Colors.red.shade400,
          fieldHeight: 50,
          // fieldWidth: 50,
          borderWidth: .7,
          selectedColor: Color(0xFFF5926D),
          selectedFillColor: Colors.white,
          activeColor: Color(0xFFF5926D),
          activeFillColor: Color(0xFFF5926D),
          inactiveColor: Color(0xFFF5926D),
          inactiveFillColor: Color(0xFFF5926D),
        ),
      );
}
