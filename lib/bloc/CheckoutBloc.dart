import 'dart:convert' as convert;

import 'package:alataf/models/LoginData.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutBloc {
  BehaviorSubject _loader = new BehaviorSubject<bool>.seeded(false);
  PublishSubject responseData = new PublishSubject<LoginData>();

  Stream get streamLoader$ => _loader.stream;
  Stream get streamUserPreferenceData$ => responseData.stream;

  saveUserPreference(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_key_value');
    print('Pressed $userData times.');
    await prefs.setString('user_key_value', data);
  }

  getUserPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userData = (prefs.getString('user_key_value') ?? "");
    print('Retrieve preference $userData');
    Map<String, dynamic> userMap = convert.jsonDecode(userData);
    var user = LoginData.fromJson(userMap);
    responseData.add(user);
    print('CheckoutBloc: key, ${user.key}!');
  }

  updateUserPreference(LoginData user) async {
    responseData.add(user);
    print('Howdy, ${user.key}!');
  }

  startLoading() {
    _loader.add(true);
  }

  stopLoading() {
    _loader.add(false);
  }

  dispose() {
    responseData.add(null);
    responseData.close();
    print("Dispose called from bloc");
  }
}
