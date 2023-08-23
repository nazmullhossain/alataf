//
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// import '../bloc/PrescriptionSubmitBloc.dart';
// import '../provider/imge_provider.dart';
// class TestImagePage extends StatefulWidget {
//   const TestImagePage({super.key});
//
//   @override
//   State<TestImagePage> createState() => _TestImagePageState();
// }
//
// class _TestImagePageState extends State<TestImagePage> {
//   File? image;
//
//   Future pickImage(BuildContext context, ImageSource source) async {
//     final image = await ImagePicker().pickImage(source: source);
//     if (image == null) return;
//     // ignore: use_build_context_synchronously
//     Provider.of<RecipeClass>(context, listen: false).image = File(image.path);
//     setState(() {});
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("ADD A PRESCRIPTION"),
//         centerTitle: true,
//
//       ),
//
//       body: Consumer<RecipeClass>(
//
//         builder: (context, provider, child) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//
//                   Row(
//                     children: [
//                       PopupMenuButton(
//
//                         itemBuilder: ((context) => [
//                           PopupMenuItem(
//                             onTap: (() =>
//                                 pickImage(context, ImageSource.camera)),
//                             child: Row(
//                               children: const [
//                                 Icon(Icons.camera_alt_outlined),
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Text('Take a picture'),
//                               ],
//                             ),
//                           ),
//                           PopupMenuItem(
//                             onTap: (() =>
//                                 pickImage(context, ImageSource.gallery)),
//                             child: Row(
//                               children: const [
//                                 Icon(Icons.image_outlined),
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Text('Select a picture'),
//                               ],
//                             ),
//                           ),
//                         ]),
//                       ),
//                       const Text(
//                         'ADD A PRESCRIPTION',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   Visibility(
//
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               provider.image = null;
//                               setState(() {});
//                             },
//                             child: const Icon(
//                               Icons.cancel_outlined,
//                               color: Colors.red,
//                             ),
//                           ),
//                           provider.image != null
//                               ? Image.file(
//                             provider.image!,
//                             width: 100,
//                             height: 100,
//                           )
//                               : Container(),
//                         ],
//                       )),
//
//                   SizedBox(height: 10,),
//
//                   ElevatedButton(
//                     onPressed: () {
//
//                       PrescriptionUploadBloc pres=PrescriptionUploadBloc();
//
//                       pres.uploadImage(provider.image!,context);
//
//                     },
//                     child: const Center(child: Text('Save')),
//                   )
//
//
//                 ],
//               ),
//             ),
//           );
//         }
//       ),
//
//
//     );
//   }
// }
