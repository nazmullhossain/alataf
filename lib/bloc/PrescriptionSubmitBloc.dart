import 'dart:convert' as convert;
import 'dart:io';

import 'package:alataf/bloc/MainBloc.dart';
import 'package:alataf/main.dart';
import 'package:alataf/models/LoginData.dart';
import 'package:alataf/models/PrescriptionUploadData.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class PrescriptionUploadBloc {
  BehaviorSubject _loader = new BehaviorSubject<bool>.seeded(false);
  PublishSubject _responseUploadData =
  new PublishSubject<PrescriptionUploadData>();

  Stream get streamLoader$ => _loader.stream;

  Stream get streamUploadResult$ => _responseUploadData.stream;

  void uploadImage(File filename,BuildContext context) async {
    LoginData loginData=LoginData();
    // LoginData login = LoginData.fromJson(jsonResponse);
    // Replace with the URL of your API
    var apiUrl = Uri.parse('http://139.59.119.57/api/prescription_upload');

    // Replace with your X-Auth-Token
    var authToken = "${getIt<MainBloc>().key}";

    // Replace with the file path to your image
    var filePath = filename.path;

    // Create a File object from the image file path
    var file = File(filePath);

    // Create a multipart request
    var request = http.MultipartRequest('POST', apiUrl);

    // Add the X-Auth-Token header
    request.headers['X-Auth-Token'] = authToken;

    // Add the image file to the request
    request.files.add(http.MultipartFile(
      'file_name',
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: filename.toString(),
    ));

    // Add other form fields if needed
    // request.fields['phone'] = '+8801604371820';
    // request.fields['password'] = '123456';

    // Send the request
    var response = await request.send();

    // Check the response
    if (response.statusCode == 200) {

      Fluttertoast.showToast(
          msg: "Prescription Image uploaded successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      print('Image uploaded successfully');

    } else {

      Fluttertoast.showToast(
          msg: "Prescription Image uploaded unsuccessful ${response.statusCode}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      print('Image upload failed with status code: ${response.statusCode}');
    }
  }


  callAPI(filename) async {
    startLoading();
    var url = "http://139.59.119.57/api/prescription_upload";

    print(url);
    print(filename);

    LoginData loginData=LoginData();

    Map<String, String> headers = {
      "Accept": "application/json",
      'Content-Type': 'multipart/form-data',
      "X-Auth-Token": "${getIt<MainBloc>().key}"
    };

    // var request = http.MultipartRequest('POST', Uri.parse(url));
    // request.files.add(await http.MultipartFile.fromPath('file_name', filename));
    // request.headers.addAll(headers);
    // var response = await request.send();

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('file_name', filename!));

    var response = await request.send();

    print('response code ---- ${response.statusCode}');

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var jsonResponse = convert.jsonDecode(result);
      PrescriptionUploadData prescriptionUploadData =
      PrescriptionUploadData.fromJson(jsonResponse);
      // prescriptionUploadData.success = "true";
      _responseUploadData.add(prescriptionUploadData);
      print("Response: $jsonResponse");
    } else {
      PrescriptionUploadData prescriptionUploadData = PrescriptionUploadData();
      // prescriptionUploadData.success = "false";
      prescriptionUploadData.msg = response.statusCode.toString();
      _responseUploadData.add(prescriptionUploadData);
      stopLoading();
      print("Request failed with status: ${response.statusCode}.");
    }
    stopLoading();
  }





  // callAPI(filename) async {
  //   startLoading();
  //   var url = apiURL + "prescription_upload";
  //
  //   print(url);
  //   print(filename);
  //
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "X-Auth-Token": "${getIt<MainBloc>().key}"
  //   };
  //
  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //   request.files.add(await http.MultipartFile.fromPath('file_name', filename));
  //   request.headers.addAll(headers);
  //   var response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     final result = await response.stream.bytesToString();
  //     var jsonResponse = convert.jsonDecode(result);
  //     PrescriptionUploadData prescriptionUploadData =
  //     PrescriptionUploadData.fromJson(jsonResponse);
  //     // prescriptionUploadData.success = "true";
  //     _responseUploadData.add(prescriptionUploadData);
  //     print("Response: $jsonResponse");
  //   } else {
  //     PrescriptionUploadData prescriptionUploadData =PrescriptionUploadData();
  //     // prescriptionUploadData.success = "false";
  //     prescriptionUploadData.msg = response.statusCode.toString();
  //     _responseUploadData.add(prescriptionUploadData);
  //     stopLoading();
  //     print("Request failed with status: ${response.statusCode}.");
  //   }
  //   stopLoading();
  // }

  startLoading() {
    _loader.add(true);
  }

  stopLoading() {
    _loader.add(false);
  }

  dispose() {
    _responseUploadData.add(null);
    _responseUploadData.close();
    print("Disposed profile bloc");
  }
}
