import 'package:alataf/models/ReOrderData.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../main.dart';
import 'MainBloc.dart';

class ReOrderBlock {
  BehaviorSubject _loader = BehaviorSubject<bool>.seeded(false);
  PublishSubject _cartData = PublishSubject<ReOrderData>();

  Stream get _streamLoader$ => _loader.stream;

  Stream get _streamResponseData$ => _cartData.stream;

  callApi(Map<String, dynamic> body) async {
    startLoading();
    var url = "http://178.128.217.96/api/get_order2";
    print(body);
    print(url);
    print("key-> ${getIt<MainBloc>().key}");
    Map<String, String> headers = {
      "Accept": "application/json",
      "X-Auth-Token": "${getIt<MainBloc>().key}",
    };
    await http
        .post(Uri.parse(url), headers: headers, body: body)
        .then((response) {
      if (response.statusCode == 200) {
        var json = convert.jsonDecode(response.body);
        print(json);
        var reorderData = ReOrderData.fromJson(json);
        if (!_cartData.isClosed) {
          _cartData.add(reorderData.data?.orderList?.data?[0].details?[0]);
        } else {
          _cartData.add(null);
        }
        stopLoading();
      }
    });
  }

  startLoading() {
    _loader.add(true);
  }

  stopLoading() {
    _loader.add(false);
  }

  dispose() {
    _cartData.add(null);
    _cartData.close();
    print("Dispose called from bloc");
  }
}
