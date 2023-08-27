import 'package:alataf/models/LoginData.dart';
import 'package:alataf/models/ProfilesData.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/checkout_screen.dart';

class ProfilesBloc {
  BehaviorSubject _loader = new BehaviorSubject<bool>.seeded(false);
  PublishSubject _responseLoginData = new PublishSubject<LoginData>();
  PublishSubject _responseProfilesData = new PublishSubject<ProfilesData>();

  Stream get streamLoader$ => _loader.stream;

  Stream get streamUserPreferenceData$ => _responseLoginData.stream;

  Stream get streamUpdateResultData$ => _responseProfilesData.stream;

  callAPI(
    Map profileMap,
    BuildContext context,
    checkout,
    products,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isWholeSale = prefs.getBool("is_owner") ?? false;
    print("Profile -> ${profileMap}");
    startLoading();
    var url = apiURL +
        "${isWholeSale ? "wholesalecustomer_profile_update" : "customer_profile_update"}";

    print("param ${""}");

    Map<String, String> headers = {
      "Accept": "application/json",
      "X-Auth-Token": "${profileMap['key']}"
    };

    var response =
        await http.post(Uri.parse(url), headers: headers, body: profileMap);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print("Response: $jsonResponse");
      ProfilesData responseData = ProfilesData.fromJson(jsonResponse);
      if (!_responseProfilesData.isClosed) {
        if (responseData.success == "true") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String userData = (prefs.getString('user_key_value') ?? "");
          print('Retrieve preference $userData');
          Map userMap = convert.jsonDecode(userData);
          userMap['customer_name'] = profileMap['name'];
          userMap['phone'] = profileMap['mobile'];
          userMap['email'] = profileMap['email'];
          userMap['gender'] = int.parse(profileMap['gender'] ?? "0");
          userMap['address'] = profileMap['address'];
          userMap['postcode'] = int.parse(profileMap['postcode'] ?? "0");
          userMap['city'] = profileMap['city'] ?? '';
          userMap['shop_name'] = profileMap['shop_name'];
          userMap['Wholesale'] = profileMap['Wholesale'];
          String jsonStringAgain = convert.jsonEncode(userMap);
          saveUserPreference(jsonStringAgain, context, products, checkout);
          _responseProfilesData.add(responseData);
        } else {
          _responseProfilesData.add(responseData);
          stopLoading();
        }
      }
    } else {
      _responseLoginData.add(null);
      stopLoading();
      print("Request failed with status: ${response.statusCode}.");
    }
    stopLoading();
  }

  saveUserPreference(
      String data, BuildContext context, products, checkout) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_key_value');
    print('Pressed $userData.');
    await prefs.setString('user_key_value', data);
    if ((checkout ?? false) == true) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (ctx) => Checkout(),
              settings: RouteSettings(
                arguments: products,
              )));
    }
  }

  getUserPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userData = (prefs.getString('user_key_value') ?? "");
    print('Retrieve preference $userData');
    Map<String, dynamic> userMap = convert.jsonDecode(userData);
    print('ProfilesBloc: Maps, $userMap!');
    //userMap['customer_name'] = "Masum";
    String jsonStringAgain = convert.jsonEncode(userMap);
    print("Again json $jsonStringAgain");

    var user = LoginData.fromJson(userMap);
    _responseLoginData.add(user);
    print('ProfilesBloc: key, ${user.key}!');
  }

  updateUserPreference(LoginData user) async {
    _responseLoginData.add(user);
    print('Howdy, ${user.key}!');
  }

  startLoading() {
    _loader.add(true);
  }

  stopLoading() {
    _loader.add(false);
  }

  dispose() {
    _responseProfilesData.add(null);
    _responseProfilesData.close();
    _responseLoginData.add(null);
    _responseLoginData.close();
    print("Disposed profile bloc");
  }
}
