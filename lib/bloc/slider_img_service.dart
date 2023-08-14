import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utilities/constants.dart';
class SliderImageService{


  Future<void> sliderImage() async {
    final String apiUrl = "https://api.example.com/data"; // Replace with your API endpoint
    final Map<String, String> queryParams = {
    "datetime": "2020-03-13"

    };

    final Uri uri = Uri.parse("$apiURL/get_advertisement2").replace(queryParameters: queryParams);

    final response = await http.post(uri);
    print("hellow${response}");

    if (response.statusCode == 200) {
      final responseData = response.body;
      // Process responseData as needed
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
  }








//   Future <void> sliderImage()async{
//     try{
//
// http.Response res=await http.post(Uri.parse("$apiURL/get_advertisement2"),
//
//
// body: {
//   "datetime": "2020-03-13"
// }
//
//
// );
// print({"slider $res"});
//
//
//     }catch(e){
//
//       print(e.toString());
//
//     }
//   }



}