import 'dart:convert' as convert;

import 'package:alataf/models/OrderHistoryData.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../main.dart';
import 'MainBloc.dart';

class HistoryBloc {
  BehaviorSubject _loader = new BehaviorSubject<bool>.seeded(false);
  PublishSubject orderHistoryData = new PublishSubject<List<Item>>();

  Stream get streamLoader$ => _loader.stream;

  Stream get streamOrderHistoryData$ => orderHistoryData.stream;

  callOrderHistoryApi(Map orderParameter) async {
    startLoading();
    var url = apiURL + "get_order2?page=all";
    print(url);

    Map<String, String> headers = {
      "Accept": "application/json",
      "X-Auth-Token": "${getIt<MainBloc>().key}"
    };

    var response =
        await http.post(Uri.parse(url), headers: headers, body: orderParameter);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print("Response: $jsonResponse");
      OrderHistoryData orderHistory = OrderHistoryData.fromJson(jsonResponse);
      if (!orderHistoryData.isClosed) {
        if ((orderHistory.data?.orderList?.data?.length ?? 0) > 0) {
          orderHistoryData.add(orderHistory.data?.orderList?.data);
        } else {
          orderHistoryData.add(null);
          stopLoading();
        }
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
    orderHistoryData.close();
    _loader.close();
    print("Dispose called from bloc");
  }
}
