


import 'dart:convert' as convert;
import 'dart:io';

import 'package:alataf/bloc/MainBloc.dart';
import 'package:alataf/main.dart';
import 'package:alataf/models/PrescriptionUploadData.dart';
import 'package:alataf/provider/imge_provider.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class PrescriptionUploadBloc {
  BehaviorSubject _loader = new BehaviorSubject<bool>.seeded(false);
  PublishSubject _responseUploadData =
  new PublishSubject<PrescriptionUploadData>();

  Stream get streamLoader$ => _loader.stream;

  Stream get streamUploadResult$ => _responseUploadData.stream;







  callAPI(filename) async {
    startLoading();
    var url = apiURL + "prescription_upload";

    print(url);
    print(filename);

    Map<String, String> headers = {
      "Accept": "application/json",
      "X-Auth-Token": "${getIt<MainBloc>().key}"
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('url', filename));
    request.headers.addAll(headers);
    var response = await request.send();
    print("mess ${response}");

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var jsonResponse = convert.jsonDecode(result);
      PrescriptionUploadData prescriptionUploadData =
      PrescriptionUploadData.fromJson(jsonResponse);
      // prescriptionUploadData.success = "true";
      _responseUploadData.add(prescriptionUploadData);
      print("Response: $jsonResponse");
    } else {
      PrescriptionUploadData prescriptionUploadData =PrescriptionUploadData();
      // prescriptionUploadData.success = "false";
      prescriptionUploadData.msg = response.statusCode.toString();
      _responseUploadData.add(prescriptionUploadData);
      stopLoading();
      print("Request failed with status: ${response.statusCode}.");
    }
    stopLoading();
  }

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

