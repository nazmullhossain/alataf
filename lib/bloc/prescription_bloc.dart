// import 'dart:convert';
// import 'dart:io';
//
// import 'package:alataf/utilities/erro_handling.dart';
// import 'package:cloudinary_public/cloudinary_public.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
//
// import '../main.dart';// class PrescriptionBloc {
// import '../models/prescription_model.dart';
// import 'MainBloc.dart';
//
////
//
//
//   void sellProduct({
//     required BuildContext context,
//
//     required String msg,
//     required String images,
//   }) async {
//
//     try {
//
//       Map<String, String> headers = {
//         "Accept": "application/json",
//         "X-Auth-Token": "${getIt<MainBloc>().key}"
//       };
//
//       final cloudinay = CloudinaryPublic("dcxalet9p", "mv5vrqix");
//       List<String> imageUrls = [];
//       for (int i = 0; i < images.length; i++) {
//         CloudinaryResponse res = await cloudinay
//             .uploadFile(CloudinaryFile.fromFile(images[i].path!, folder: "pres"));
//         imageUrls.add(res.secureUrl);
//       }
//
//    PrescriptionModel prescriptionModel=PrescriptionModel(msg: msg, url: images);
//       http.Response res = await http.post(
//         Uri.parse('$url/prescription_upload'),
//         body: prescriptionModel.toJson(),
//         headers: headers
//       );
//       httpErrorHandle(
//           response: res,
//           context: context,
//           onSuccess: () {
//             showSnackBar(context, "Product Added Sucessfully!");
//             Navigator.pop(context);
//           });
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }
//
//
// }
