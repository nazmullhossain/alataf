import 'package:alataf/screens/prescription_submit_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alataf/main.dart';
import 'package:alataf/screens/prescription_upload_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';

class UploadPrescription extends StatefulWidget {
  @override
  UploadPrescriptionState createState() {
    return UploadPrescriptionState();
  }
}

class UploadPrescriptionState extends State<UploadPrescription> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              closeButton(context),
              SizedBox(height: 16),
              Icon(LineAwesomeIcons.hospital_1, size: 120, color: Colors.green),
              SizedBox(height: 20),
              Text("Upload your prescription",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
              SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        "Upload an image of your prescription from that to proof that "
                            "you have real prescription",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              SizedBox(height: 50),
              uploadImage(context),
              SizedBox(height: 8),
              Text("Or", style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              takeNewImage(context),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

Widget uploadImage(BuildContext context) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 54,
        width: 180,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrescriptionSubmit(),
                  ));
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Color(0xFFF5926D))),
              backgroundColor: Color(0xFFF5926D),
              elevation: 8.0,
            ),
            child: Text(
              "UPLOAD IMAGE",
              style: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
            )),
      ),
    ],
  );
}

Widget takeNewImage(BuildContext context) {
  return Column(
    children: <Widget>[
      SizedBox(
        width: 180,
        height: 54,
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Color(0xFFF5926D))),
              backgroundColor: Color(0xFFF5926D),
              elevation: 8.0,
            ),
            child: Text(
              "TAKE NEW IMAGE",
              style: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
            )),
      ),
    ],
  );
}

Widget closeButton(BuildContext context) {
  return Container(
    alignment: Alignment.topRight,
    child: CircleAvatar(
      backgroundColor: Colors.black12,
      radius: 20,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.close),
        color: Colors.black87,
        onPressed: () {
          //databaseConfig.getProducts();
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
