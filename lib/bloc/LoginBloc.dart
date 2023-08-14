import 'package:alataf/bloc/MainBloc.dart';
import 'package:alataf/models/LoginData.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginBloc {
  BehaviorSubject _loader = new BehaviorSubject<bool>.seeded(false);
  PublishSubject responseData = new PublishSubject<LoginData>();

  Stream get streamLoader$ => _loader.stream;

  Stream get streamResponseData$ => responseData.stream;

  callAPI(Map data, {required bool isWholeSale}) async {
    startLoading();
    var url = apiURL + "${isWholeSale ? "wholesaleLogin" : "login"}";
    // ?password=${data['password']}&"
    //     "phone=${data['phone']}";
    print(data);
    print(url);
    print("is whole sale -> ${isWholeSale}");

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    await http
        .post(Uri.parse(url),
            body: {
              "password": data['password'],
              'phone': data['phone'],
            },
            headers: headers)
        .then((response) async {
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        print("Response print: $jsonResponse");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("is_owner", isWholeSale);
        getUserPreference();
        LoginData login = LoginData.fromJson(jsonResponse);

        if (!responseData.isClosed) {
          if (login.success == "true") {
            print("Response true: $jsonResponse");
            print("Response true: ${login.message}");
            getIt<MainBloc>().key = login.key ?? "";
            _saveUserPreference(response.body);
            responseData.add(login);
          } else {
            print("Response false: $jsonResponse");
            print("Response false: ${login.message}");
            if (isWholeSale) {
              responseData.add(login);
              _loader.add(false);
            } else {
              callAPI(data, isWholeSale: true);
            }
          }
        }
      } else {
        print("Request failed with status: ${response.statusCode}.");
      }
      stopLoading();
    });
  }

  _saveUserPreference(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_key_value');
    print('Pressed $userData times.');
    await prefs.setString('user_key_value', data);
  }

  getUserPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userData = (prefs.getString('user_key_value') ?? "");
    print('Retrieved preference $userData');
    if (userData.isNotEmpty) {
      Map<String, dynamic> userMap = convert.jsonDecode(userData);
      var user = LoginData.fromJson(userMap);

      print('Howdy, ${user.key}!');
    }
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
