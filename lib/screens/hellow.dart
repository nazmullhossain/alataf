
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../bloc/MainBloc.dart';
import '../main.dart';

class PrescriptionUploadPage extends StatefulWidget {
  @override
  _PrescriptionUploadPageState createState() => _PrescriptionUploadPageState();
}

class _PrescriptionUploadPageState extends State<PrescriptionUploadPage> {
  File? _image;
  String _description = '';

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadData() async {
    if (_image == null) {
      // Handle case where image is not selected
      return;
    }

    final Uri url = Uri.parse('http://139.59.119.57/api/prescription_upload');
    var request = http.MultipartRequest('POST', url);
    Map<String, String> headers = {
      "Accept": "application/json",
      "X-Auth-Token": "${getIt<MainBloc>().key}"
    };
    request.headers.addAll(headers);

    // Add image file to the request
    request.files.add(await http.MultipartFile.fromPath('file_name',   // Field name on the server
     _image!.path,
    ));
    request.headers.addAll(headers);
    final response = await request.send();
    // Add string data to the request
    request.fields['msg'] = _description;

    try {

      final response = await request.send();
      request.headers.addAll(headers);
      if (response.statusCode == 200) {
        // Successful upload, handle response if needed
        print('Upload success');
      } else {
        // Handle error
        print('Upload failed with status ${response.statusCode}');
      }
    } catch (error) {
      // Handle upload error
      print('Error uploading: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Prescription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _image != null
                ? Image.file(
              _image!,
              height: 200,
            )
                : SizedBox(height: 200, child: Center(child: Text('No Image'))),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pick Image from Gallery'),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  // _description = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadData,
              child: Text('Upload Data'),
            ),
          ],
        ),
      ),
    );
  }
}


