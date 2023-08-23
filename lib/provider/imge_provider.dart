import 'dart:io';

import 'package:alataf/models/Products.dart';
import 'package:flutter/material.dart';
import '../bloc/hitory_database.dart';
import '../bloc/search_text_bloc.dart';

import '../models/search_new_models.dart';

class RecipeClass extends ChangeNotifier {
  RecipeClass() {
    getRecipes();
  }



  File? image;


  List<ProductItem> allRecipes = [];

  getRecipes() async {
    allRecipes = await DbHelper.dbHelper.getAllRecipes();
    notifyListeners();

  }


  deleteAll(){
    DbHelper.dbHelper.deleteRecipes();

  }


}



