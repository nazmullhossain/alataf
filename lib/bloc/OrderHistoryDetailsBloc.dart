import 'package:alataf/bloc/MainBloc.dart';
import 'package:alataf/models/LoginData.dart';
import 'package:alataf/models/OrderCancelData.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class OrderHistoryDetailsBloc {
  BehaviorSubject _loader = new BehaviorSubject<bool>.seeded(false);
  PublishSubject responseData = new PublishSubject<OrderCancelData>();

  Stream get streamLoader$ => _loader.stream;

  Stream get streamResponseData$ => responseData.stream;

  orderCancelApi(Map data) async {
    startLoading();
    var url = apiURL + "cancel_order";
    print(data);
    print(url);

    Map<String, String> headers = {
      "Accept": "application/json",
      "X-Auth-Token": "${getIt<MainBloc>().key}"
    };

    var response =
        await http.post(Uri.parse(url), headers: headers, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print("Response print: $jsonResponse");

      try {
        OrderCancelData login = OrderCancelData.fromJson(jsonResponse);
        if (!responseData.isClosed) {
          if (login.message?.contains("Canceled") ?? true) {
            login.success = "true";
            responseData.add(login);
          } else {
            login.success = "false";
            responseData.add(login);
            stopLoading();
          }
        }
      } catch (e) {
        OrderCancelData login = OrderCancelData();
        login.success = "false";
        responseData.add(login);
        stopLoading();
      }
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }

    stopLoading();
  }

  startLoading() {
    _loader.add(true);
  }

  stopLoading() {
    _loader.add(false);
  }

  dispose() {
    // responseData.add(null);
    responseData.close();
    print("Dispose called from bloc");
  }
}
