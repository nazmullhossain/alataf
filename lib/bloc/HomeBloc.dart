import 'package:alataf/main.dart';
import 'package:alataf/models/AdvertisementData.dart';
import 'package:alataf/models/LoginData.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'MainBloc.dart';

class HomeBloc {
  BehaviorSubject _isLoggedIn = new BehaviorSubject<bool>();
  BehaviorSubject _loader = new BehaviorSubject<bool>();
  PublishSubject advertisementData = new PublishSubject<AdvertisementData>();

  Stream get streamLoader$ => _loader.stream;

  Stream get streamAdvertisementData$ => advertisementData.stream;

  Stream get streamLoginStatus$ => _isLoggedIn.stream;

  String get currentText => _loader.value;

  callAdvertisementAPI(String text) async {
    var url = "http://178.128.217.96/api/get_advertisement?datetime=2020-03-15";
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
          advertisementData.add(advertisement);
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
    print('Retrieved preference $userData');

    if (userData.length > 0) {
      Map<String, dynamic> userMap = convert.jsonDecode(userData);
      var user = LoginData.fromJson(userMap);
      if (user.success == "true") {
        _isLoggedIn.add(true);
        getIt<MainBloc>().key = user.key ?? "";
      } else {
        _isLoggedIn.add(false);
      }
    }
  }

  saveUserPreference(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_key_value');
    print('After saving preference data $userData');
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
    print("Dispose called from bloc");
  }
}
