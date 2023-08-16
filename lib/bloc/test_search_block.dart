// import 'dart:convert';
//
// import 'package:alataf/models/product_models.dart';
// import 'package:rxdart/rxdart.dart';
//
// import '../models/search_model.dart';
// import '../utilities/constants.dart';
// import 'package:http/http.dart' as http;
// PublishSubject searchData = new PublishSubject<List<ProductList>>();
// Stream get streamProducts$ => searchData.stream;
// class TestSearch{
//
//
//
//
//
//
//
//
//
//   searchData()async{
//     Map<String, String> headers = {
//       "Accept": "application/json",
//     };
//
//     var url = apiURL + "search_product?search=nap&page=1";
//
//     var response = await http.post(Uri.parse(url));
//     print("search${response.body}");
//
//     if(response.statusCode==200){
//       var jsonResponse =jsonDecode(response.body);
//
//
//       ProductModel productModel=ProductModel.fromJson(jsonResponse);
//
//       if (!searchData.isClosed) {
//         if ((products.data?.productList?.length ?? 0) > 0) {
//           searchData.add(products.data?.productList);
//         } else {
//           searchData.add(null);
//           _loader.add(false);
//         }
//       }
//
//
//
//     }
//
//
//
//
//
//
//
//   }
//
//
// }