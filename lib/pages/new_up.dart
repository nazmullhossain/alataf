import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../bloc/PrescriptionSubmitBloc.dart';
import '../provider/imge_provider.dart';


class NewRecipeScreen extends StatefulWidget {
  const NewRecipeScreen({super.key});

  @override
  State<NewRecipeScreen> createState() => _NewRecipeScreenState();
}

class _NewRecipeScreenState extends State<NewRecipeScreen> {
  Future pickImage(BuildContext context, ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    // ignore: use_build_context_synchronously
    Provider.of<RecipeClass>(context, listen: false).image = File(image.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Prescription'),
        ),
        body: Consumer<RecipeClass>(
          builder: (context, provider, child) => SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      PopupMenuButton(

                        itemBuilder: ((context) => [
                          PopupMenuItem(
                            onTap: (() =>
                                pickImage(context, ImageSource.camera)),
                            child: const Row(
                              children: [
                                Icon(Icons.camera_alt_outlined),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Take a picture'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            onTap: (() =>
                                pickImage(context, ImageSource.gallery)),
                            child: const Row(
                              children: [
                                Icon(Icons.image_outlined),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Select a picture'),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      const Text(
                        'ADD A PICTURE',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: provider.image != null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              provider.image = null;
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                          ),
                          provider.image != null
                              ? Image.file(
                            provider.image!,
                            width: 100,
                            height: 100,
                          )
                              : Container(),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),


                  ElevatedButton(
                    onPressed: ()async {

                      PrescriptionUploadBloc pres=PrescriptionUploadBloc();

                      pres.uploadImage(provider.image!,context);
                      print("no data found");

                      Navigator.pop(context);
                      provider.image = null;




                    },
                    child: const Center(child: Text('Upload your Prescription')),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
