import 'dart:convert';

import 'package:alataf/models/AdvertisementData.dart';
import 'package:alataf/models/LoginData.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../models/info_model.dart';

class OfferBloc {
  BehaviorSubject _isLoggedIn = new BehaviorSubject<bool>();
  BehaviorSubject _loader = new BehaviorSubject<bool>();
  PublishSubject advertisementData = new PublishSubject<List<Insert>>();

  Stream get streamLoader$ => _loader.stream;
  Stream get streamAdvertisementData$ => advertisementData.stream;
  Stream get streamLoginStatus$ => _isLoggedIn.stream;
  String get currentText => _loader.value;

  //slider

  Future<List<Insertt>> getData(BuildContext context) async {
    List<Insertt> insertData = [];
    List<Insertt> offerTypeAdvertisement = [];
    final String url =
        "http://139.59.119.57/api/get_advertisement?datetime=2020-03-13";
    // get_advertisement?datetime=2020-03-13
    try {
      http.Response res = await http.post(Uri.parse(url));
      print("image ${res.body}");

      if (res.statusCode == 200) {
        var jsonRes = jsonDecode(res.body);
        print(jsonRes);

        InfoData advertisement = InfoData.fromJson(jsonRes);

        for (Insertt advertisement in advertisement.insert!) {
          if (advertisement.bannerType == "home_banner") {
            offerTypeAdvertisement.add(advertisement);
            print(offerTypeAdvertisement);
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return offerTypeAdvertisement;
  }

  // http://139.59.119.57
  callAdvertisementAPI(String text) async {
    startLoading();
    var url = "http://139.59.119.57/api/get_advertisement?datetime=2020-03-15";
    print(url);

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    var response = await http.post(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print("Response: $jsonResponse");
      AdvertisementData advertisement =
          AdvertisementData.fromJson(jsonResponse);
      if (!advertisementData.isClosed) {
        if ((advertisement.insert?.length ?? 0) > 0) {
          List<Insert> offerTypeAdvertisement = [];
          for (Insert advertisement in advertisement.insert!) {
            if (advertisement.bannerType == "offer") {
              offerTypeAdvertisement.add(advertisement);
            }
          }
          advertisementData.add(offerTypeAdvertisement);
        } else {
          advertisementData.add(null);
          _loader.add(false);
        }
      }
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    stopLoading();
  }

  getUserPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userData = (prefs.getString('user_key_value') ?? "");
    print('Retrieved preference offer bloc $userData');
    Map<String, dynamic> userMap = convert.jsonDecode(userData);
    var user = LoginData.fromJson(userMap);
    if (user.success == "true") {
      _isLoggedIn.add(true);
      print('Howdy, ${user.key}!');
    } else {
      _isLoggedIn.add(false);
    }
  }

  saveUserPreference(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_key_value');
    print('Pressed $userData times.');
    await prefs.setString('user_key_value', data);
  }

  getInfo(String text) {
    advertisementData.add(null);
    startLoading();
    callAdvertisementAPI(text);
  }

  startLoading() {
    _loader.add(true);
  }

  stopLoading() {
    _loader.add(false);
  }

  dispose() {
    advertisementData.close();
    _loader.close();
    print("Dispose called from bloc");
  }
}
