import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
})async{
  switch(response.statusCode){
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context,jsonDecode(response.body)['msg']);
      break;
    default:
      showSnackBar(context,response.body);

  }
}


void showSnackBar(BuildContext context,String text){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text))
  );
}