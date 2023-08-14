import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alataf/bloc/CartDetailsBloc.dart';
import 'package:alataf/main.dart';
import 'package:alataf/models/OrderConfirmData.dart';
import 'package:alataf/models/PrescriptionUploadData.dart';
import 'package:alataf/screens/home_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


class PrescriptionSubmitComplete extends StatefulWidget {
  @override
  PrescriptionSubmitCompleteState createState() {
    return PrescriptionSubmitCompleteState();
  }
}

class PrescriptionSubmitCompleteState
    extends State<PrescriptionSubmitComplete> {
  @override
  Widget build(BuildContext context) {
    final PrescriptionUploadData prescriptionUploadData =
        ModalRoute.of(context)?.settings.arguments as PrescriptionUploadData;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16),
              (prescriptionUploadData.success == "true")
                  ? Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 60,
                      ),
                    )
                  : Icon(
                      LineAwesomeIcons.parking,
                      color: Colors.red,
                      size: 60,
                    ),
              SizedBox(height: 30),
              Text(prescriptionUploadData.msg ?? "",
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 60),
              buttonDone(context, prescriptionUploadData),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonDone(
      BuildContext context, PrescriptionUploadData orderConfirmData) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 50,
          child: ElevatedButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
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
                "DONE",
                style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF)),
              )),
        ),
      ],
    );
  }
}

goBackToHome(BuildContext context) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => Home()),
      (Route<dynamic> route) => route is Home);
}

Widget closeButton(BuildContext context) {
  return Container(
    alignment: Alignment.topRight,
    child: TextButton(
      onPressed: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Icon(
        Icons.close,
        size: 35,
        color: Colors.grey,
      ),
    ),
  );
}
