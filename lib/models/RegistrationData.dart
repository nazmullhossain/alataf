import 'package:json_annotation/json_annotation.dart';

class RegistrationData {
  String? success;
  String? stringMessage;
  Message? message;

  @JsonKey(required: true)
  String? key;

  RegistrationData({this.success, this.stringMessage, this.message, this.key});

  RegistrationData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (success == "false") {
      message = json['message'] != null
          ? new Message.fromJson(json['message'])
          : null;
    } else {
      stringMessage = json['message'];
    }
    key = json['key'] != null ? json['key'] : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.message != null) {
      data['message'] = this.message?.toJson();
    }
    return data;
  }
}

class Message {
  List<String>? mobile;
  List<String>? email;

  Message({this.mobile, this.email});

  Message.fromJson(Map<String, dynamic> json) {
    //mobile = json['mobile'].cast<String>();
    List<String> emailEmptyMessage = [];
    emailEmptyMessage.add("");
    mobile = json['mobile'] != null
        ? json['mobile'].cast<String>()
        : emailEmptyMessage;
    email = json['email'] != null
        ? json['email'].cast<String>()
        : emailEmptyMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    return data;
  }
}
