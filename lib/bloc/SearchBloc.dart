import 'package:alataf/bloc/search_text_bloc.dart';
import 'package:alataf/models/Products.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Database.dart';



class SearchBloc   extends ChangeNotifier{
  BehaviorSubject _loader = new BehaviorSubject<bool>();
  PublishSubject searchData = new PublishSubject<List<ProductItem>>();
  List<ProductItem> products = [];

  Stream get streamLoader$ => _loader.stream;
  Stream get streamProducts$ => searchData.stream;
  String get currentText => _loader.value;

  callAPI(String text) async {
    if (text.isEmpty || text.length < 2) {
      // searchData.add(null);
      _loader.add(false);
      return;
    }

    // var url = apiURL + "search_product?search=$text&page=1";
    var url = apiURL + "search_product?page=1&search=" +
        text;


    print(url);

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    var response = await http.post(Uri.parse(url), headers: headers);
    print("search ${response}");
    if (response.statusCode == 200) {
      print("Response: $response.");
      var jsonResponse = convert.jsonDecode(response.body);
      //print("Response: $jsonResponse");
      Products products = Products.fromJson(jsonResponse);







      // List<ProductItem> allRecipes = [];
      //     ProductItem productItem=ProductItem(
      //       categoryName: jsonResponse['product_name'],
      //       companyName: jsonResponse['companyName'],
      //       genericName: jsonResponse['genericName'],
      //
      //
      //       price: jsonResponse['price'],


      // DatabaseConfig databaseConfig=DatabaseConfig();
      //
      // ProductItem productItem=ProductItem();
      // databaseConfig.createCustomer(productItem, 1);
      // // DbHelper.dbHelper.insertNewRecipe(productItem);
      //





      if (!searchData.isClosed) {
        if ((products.data?.productList?.length ?? 0) > 0) {
          searchData.add(products.data?.productList);


          // DbHelper dbHelper=DbHelper();

          // dbHelper.insertNewRecipe(products.data as ProductItem);



        }
      }
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }

    stopLoading();
  }








  getInfo(String text) {
    // searchData.add(null);
    startLoading();
    callAPI(text);
  }

  startLoading() {
    _loader.add(true);
  }

  stopLoading() {
    _loader.add(false);
  }

  dispose() {
    searchData.close();
    _loader.close();
    print("Dispose called from bloc");
  }
}
