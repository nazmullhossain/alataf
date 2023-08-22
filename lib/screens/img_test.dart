import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';


// class ImageUploadScreen extends StatelessWidget {
//
//   // final String imagePath = 'assets/images/al_ataf_logo.jpg'; // Update this to your image path
//
//
//
//     // var request = http.MultipartRequest('POST', Uri.parse(url));
//     // request.files.add(await http.MultipartFile.fromPath('file_name', filename));
//     // request.headers.addAll(headers);
//     // var response = await request.send();
//
//     var request = http.MultipartRequest('POST', Uri.parse(url))
//       ..headers.addAll(headers)
//       ..files.add(await http.MultipartFile.fromPath('file_name', filename!));
//
//     var response = await request.send();
//
//     print('response code ---- ${response.statusCode}');
//
//     if (response.statusCode == 200) {
//       final result = await response.stream.bytesToString();
//       var jsonResponse = convert.jsonDecode(result);
//       PrescriptionUploadData prescriptionUploadData =
//       PrescriptionUploadData.fromJson(jsonResponse);
//       // prescriptionUploadData.success = "true";
//       _responseUploadData.add(prescriptionUploadData);
//       print("Response: $jsonResponse");
//     } else {
//       PrescriptionUploadData prescriptionUploadData = PrescriptionUploadData();
//       // prescriptionUploadData.success = "false";
//       prescriptionUploadData.msg = response.statusCode.toString();
//       _responseUploadData.add(prescriptionUploadData);
//       stopLoading();
//       print("Request failed with status: ${response.statusCode}.");
//     }
//     stopLoading();
//   }



  Future<void> uploadImage(String imagePath) async {
    final String apiUrl = 'http://139.59.119.57/api/prescription_upload';
    final String authToken = '4fhuoEZPbyvgrLHxu8I3xUAyhdHkCpGyFs2q8JBOcbMefaL82f';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['X-Auth-Token'] = authToken;

    // Attach the image file to the request
    var image = await http.MultipartFile.fromPath('file_name', imagePath);
    request.files.add(image);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Image upload failed with status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){},
          child: Text('Upload Image'),
        ),
      ),
    );
  }

