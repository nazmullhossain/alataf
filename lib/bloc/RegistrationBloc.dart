import 'package:alataf/models/LoginData.dart';
import 'package:alataf/models/RegistrationData.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationBloc {
  BehaviorSubject _loader = new BehaviorSubject<bool>.seeded(false);
  PublishSubject responseData = new PublishSubject<RegistrationData>();

  Stream get streamLoader$ => _loader.stream;
  Stream get streamResponseData$ => responseData.stream;
  String get currentText => _loader.value;

  callAPI(Map<String, String> data, {required bool isWholeSale}) async {
    startLoading();
    print("is whole sale ------------- ${isWholeSale}");
    var url = apiURL +
        "${isWholeSale ? "wholesale_customer_registration" : "register"}";
    // ?name=${data['name']}&"
    // "mobile=${data['mobile']}&"
    // "email=${data['email']}&"
    // "postcode=${data['postcode']}&"
    // "city=${data['city']}&"
    // "address=${data['address']}&"
    // "gender=${data['gender']}&"
    // "password=${data['password']}&"
    // "password_confirmation=${data['password_confirmation']}&"
    // "app_version=${data['app_version']}&"
    // "${isWholeSale ? "shop_owner_name=${data['shop_owner_name']}&" : ""}"
    // "${isWholeSale ? "shop_owner_address=${data['shop_owner_address']}&" : ""}"
    // "${isWholeSale ? "trade_license=${data['trade_license']}" : ""}
    // ";
    print(data);
    print(url);
    print("is whole sale -> ${isWholeSale}");

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    var response = await http.post(
      Uri.parse(url),
      body: isWholeSale
          ? data
          : {
              "name": data['name'],
              'mobile': data['mobile'],
              'password': data['password'],
              'password_confirmation': data['password_confirmation'],
              'app_version': data['app_version'],
              if (isWholeSale) "trade_license": data['trade_license'],
            },
      headers: headers,
    );
    print("response reg --------- ${response.statusCode}");
    print("body ------------ ${response.body}");
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print("Response print: $jsonResponse");

      RegistrationData registrationResult =
          RegistrationData.fromJson(jsonResponse);
      if (!responseData.isClosed) {
        if (registrationResult.success == "true") {
          print("Response true: $jsonResponse");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("is_owner", isWholeSale);
          print("reg data -> ${data}");
          callAutoLoginIfRegistrationSuccess(data, registrationResult,
              isWholeSale: isWholeSale);
        } else {
          print("Response false: $jsonResponse");
          print("Response false: ${registrationResult.message?.email?[0]}");
          print("Response false: ${registrationResult.message?.mobile?[0]}");
          responseData.add(registrationResult);
          stopLoading();
        }
      }
    } else {
      print("Request failed with status: ${response.statusCode}.");
      stopLoading();
    }
  }

  void callAutoLoginIfRegistrationSuccess(
      Map data, RegistrationData registrationResult,
      {required bool isWholeSale}) {
    print("login data -> ${data}");
    var loginCredential = {
      'mobile': data['mobile'],
      'password': data['password'],
    };
    callLoginAPI(loginCredential, registrationResult,
        isWholeSale: isWholeSale); //Auto login if registration success
  }

  callLoginAPI(Map data, RegistrationData registrationResult,
      {required bool isWholeSale}) async {
    //startLoading();
    var url = apiURL + "${isWholeSale ? "wholesaleLogin" : "login"}";
    // ?password=${data['password']}&"
    //     "phone=${data['mobile']}";

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    var response = await http.post(Uri.parse(url),
        body: {
          "password": data['password'],
          "phone": data['mobile'],
        },
        headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      LoginData login = LoginData.fromJson(jsonResponse);
      if (!responseData.isClosed) {
        print("login -> ${login.message}");
        if (login.success == "true") {
          responseData.add(registrationResult);
          _saveUserPreference(response.body);
        } else {
          // responseData.add(login);
          stopLoading();
        }
      }
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }

    stopLoading();
  }

  _saveUserPreference(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_key_value');
    print('Pressed $userData times.');
    await prefs.setString('user_key_value', data);
  }

  getInfo(String text) {
    responseData.add(null);
    startLoading();
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
    _loader.close();
    print("Dispose called from bloc");
  }
}
