import 'dart:convert';

import 'package:alataf/models/AdvertisementData.dart';
import 'package:alataf/models/LoginData.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../models/info_model.dart';
import '../models/off_model.dart';

class NewOfferBloc {
  BehaviorSubject _isLoggedIn = new BehaviorSubject<bool>();
  BehaviorSubject _loader = new BehaviorSubject<bool>();
  PublishSubject advertisementData = new PublishSubject<List<Dataaa>>();


  Stream get streamLoader$ => _loader.stream;
  Stream get streamAdvertisementData$ => advertisementData.stream;

  Stream get streamLoginStatus$ => _isLoggedIn.stream;
  String get currentText => _loader.value;



  // http://139.59.119.57
  callAPI(String text) async {
    startLoading();
    var url = "http://139.59.119.57/api/get_advertisement2?datetime=2020-03-13";
    print(url);

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    var response = await http.post(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print("Response: $jsonResponse");
      OfferModel advertisement =
      OfferModel.fromJson(jsonResponse);
      if (!advertisementData.isClosed) {
        if ((advertisement.data?.length ?? 0) > 0) {
          List<Dataaa> offerTypeAdvertisement = [];
          for (Dataaa advertisement in advertisement.data!) {
            if (advertisement.bannerType == "offer") {
              offerTypeAdvertisement.add(advertisement);
            }
          }
          print("offerTypeAdvertisement ${offerTypeAdvertisement}");
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
    callAPI(text);
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
