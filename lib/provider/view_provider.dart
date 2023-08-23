// import 'package:flutter/cupertino.dart';
//
// import '../models/LoginData.dart';
//
//
//
// class UserProvider extends ChangeNotifier{
//   LoginData _user =LoginData(
//
//       key: "",
//
//   );
//
//   LoginData get user=>_user;
//
//   void setUser(String user){
//     _user=LoginData.fromJson(user );
//     notifyListeners();
//   }
//   void setUserFromModel(LoginData user){
//     _user=user;
//     notifyListeners();
//   }
// }