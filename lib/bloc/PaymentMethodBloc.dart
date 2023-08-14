import 'dart:convert' as convert;

import 'package:alataf/models/OrderConfirmData.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class PaymentMethodBloc {
  BehaviorSubject _loader = new BehaviorSubject<bool>.seeded(false);
  PublishSubject _orderResponseData = new PublishSubject<OrderConfirmData>();

  Stream get streamLoader$ => _loader.stream;

  Stream get streamConfirmResponse$ => _orderResponseData.stream;

  String get currentText => _loader.value;

  callAPI(Map orderReadyItem) async {
    startLoading();
    // order_create
    var url = apiURL +
        "order_create?product_id=${orderReadyItem['product_id']}"
            "&quantity=${orderReadyItem['quantity']}"
            "&ref_no=${orderReadyItem['ref_no']}"
            "&discount=${orderReadyItem['discount']}"
            "&remarks=${orderReadyItem['remarks']}"
            "&address=${orderReadyItem['address']}"
            "&tran_id=${orderReadyItem['tran_id']}"
            "&phone=${orderReadyItem['phone']}";

    debugPrint("phone number-> ${orderReadyItem["phone"]}");
    debugPrint("remarks-> ${orderReadyItem["remarks"]}");

    print("url -> ${url}");

    print("hello token -> ${orderReadyItem['key']}");

    Map<String, String> headers = {
      "Accept": "application/json",
      "X-Auth-Token": "${orderReadyItem['key']}"
    };

    var response = await http.post(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print("Response: $jsonResponse");
      OrderConfirmData responseData = OrderConfirmData.fromJson(jsonResponse);
      if (!_orderResponseData.isClosed) {
        if (responseData.success == "true") {
          _orderResponseData.add(responseData);
        } else {
          _orderResponseData.add(responseData);
          _loader.add(false);
        }
      }
    } else {
      _orderResponseData.add(null);
      _loader.add(false);
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
    _orderResponseData.close();
    _loader.close();
    print("Dispose called from bloc");
  }
}
