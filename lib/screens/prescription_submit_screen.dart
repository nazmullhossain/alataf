import 'dart:io';

import 'package:alataf/bloc/PrescriptionSubmitBloc.dart';
import 'package:alataf/models/PrescriptionUploadData.dart';
import 'package:alataf/screens/prescription_submit_complete_screen.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:toast/toast.dart';

class PrescriptionSubmit extends StatefulWidget {
  @override
  PrescriptionSubmitState createState() {
    return PrescriptionSubmitState();
  }
}

class PrescriptionSubmitState extends State<PrescriptionSubmit> {
  dynamic _pickImageError;
  bool isVideo = false;
  String? _retrieveDataError;
  PrescriptionUploadBloc _prescriptionBloc = PrescriptionUploadBloc();

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError ?? "");
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImage(PickedFile _imageFile) {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              _imageFile.path,
              height: 200.0,
              fit: BoxFit.cover,
            ));
      } else {
        return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.file(File(_imageFile.path),
                height: 200.0, fit: BoxFit.cover));
        //Image.file(File(_imageFile.path));
      }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget uploadImage(BuildContext context, PickedFile _imageFile) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 54,
          width: 180,
          child: ElevatedButton(
              onPressed: () {
                _prescriptionBloc.callAPI(_imageFile.path);
              },
              style: ElevatedButton.styleFrom(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xFFF5926D))),
                backgroundColor: Color(0xFFF5926D),
              ),
              child: Text(
                "SUBMIT",
                style: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
              )),
        ),
      ],
    );
  }

  showToast() {
    Fluttertoast.showToast(msg: "Something went wrong!!",
        // duration: Toast.LENGTH_SHORT,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white);
  }

  @override
  void initState() {
    super.initState();
    _prescriptionBloc.streamUploadResult$.listen((data) {
      PrescriptionUploadData prescriptionUploadData = data;
      if (prescriptionUploadData.success == "true") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PrescriptionSubmitComplete(),
                  settings: RouteSettings(
                    arguments: prescriptionUploadData,
                  )));
        });

        Navigator.pop(context);
      } else {
        showToast();
      }
    });
  }

  @override
  void dispose() {
    _prescriptionBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PickedFile pickedFile =
        ModalRoute.of(context)?.settings.arguments as PickedFile;
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
              SizedBox(height: 80),
              Center(child: _previewImage(pickedFile)),
              SizedBox(height: 24),
              Text("Submit your prescription",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              //SizedBox(height: 16),
              Expanded(child: SizedBox()),
              StreamBuilder(
                  stream: _prescriptionBloc.streamLoader$,
                  builder: (context, snapshot) {
                    if (snapshot.data) {
                      return spinCircleLoader;
                    } else {
                      return uploadImage(context, pickedFile);
                    }
                  }),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

Widget proceedToCheckout(BuildContext context) {
  return Column(
    children: <Widget>[
      Container(
        alignment: Alignment.center,
        height: 50,
        child: ElevatedButton(
            onPressed: () {},
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
