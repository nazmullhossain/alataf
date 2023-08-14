import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alataf/screens/prescription_submit_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:video_player/video_player.dart';

class PrescriptionUpload extends StatefulWidget {
  PrescriptionUpload({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _PrescriptionUploadState createState() => _PrescriptionUploadState();
}

class _PrescriptionUploadState extends State<PrescriptionUpload> {
  PickedFile? _imageFile;
  dynamic _pickImageError;
  bool isVideo = false;
  VideoPlayerController? _controller;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _disposeVideoController() async {
    if (_controller != null) {
      await _controller?.dispose();
      _controller = null;
    }
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget() ?? Text("");
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PrescriptionSubmit(),
                settings: RouteSettings(
                  arguments: _imageFile,
                )));

        setState(() {
          _imageFile = null;
        });
      });

      if (kIsWeb) {
        // Why network?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        return Image.network(_imageFile?.path ?? "");
      } else {
        return Image.file(File(_imageFile?.path ?? ""));
      }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        '',
        textAlign: TextAlign.center,
      );
    }
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    if (_controller != null) {
      await _controller?.setVolume(0.0);
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: null,
        maxHeight: null,
        imageQuality: 100,
      );
      setState(() {
        _imageFile = pickedFile as PickedFile?;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  // Future<void> retrieveLostData(ImageSource source) async {
  //   final LostData response = (await _picker.pickImage(source: source)) as LostData;
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     isVideo = false;
  //     setState(() {
  //       _imageFile = response.file;
  //     });
  //   } else {
  //     _retrieveDataError = response.exception!.code;
  //   }
  // }

  Widget uploadImage(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 54,
          width: 180,
          child: ElevatedButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xFFF5926D))),
                backgroundColor: Color(0xFFF5926D),
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
              onPressed: () {
                isVideo = false;
                _onImageButtonPressed(ImageSource.camera, context: context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xFFF5926D))),
                backgroundColor: Color(0xFFF5926D),
              ),
              child: Text(
                "TAKE NEW IMAGE",
                style: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
              )),
        ),
      ],
    );
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller?.setVolume(0.0);
      _controller?.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ), systemOverlayStyle: SystemUiOverlayStyle.dark),
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        child: Column(
          children: <Widget>[
            Center(
              child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                  ? FutureBuilder<void>(
                      // future: retrieveLostData(),
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Text(
                              'You have not yet picked an image.',
                              textAlign: TextAlign.center,
                            );
                          case ConnectionState.done:
                            {
                              print("picked Done");
                              return _previewImage();
                            }

                          default:
                            if (snapshot.hasError) {
                              return Text(
                                'Pick image/video error: ${snapshot.error}}',
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return const Text(
                                'You have not yet picked an image.',
                                textAlign: TextAlign.center,
                              );
                            }
                        }
                      },
                    )
                  : _previewImage(),
            ),
            SizedBox(height: 16),
            Icon(LineAwesomeIcons.hospital_1, size: 120, color: Colors.green),
            SizedBox(height: 20),
            Text("Upload your prescription",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
            SizedBox(height: 16),
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
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError ?? "");
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);
