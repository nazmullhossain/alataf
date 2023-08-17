import 'dart:io';

import 'package:flutter/material.dart';


class RecipeClass extends ChangeNotifier {
  RecipeClass() {

  }

  bool isDark = false;
  changeIsDark() {
    isDark = !isDark;
    notifyListeners();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController preperationTimeController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  File? image;




}