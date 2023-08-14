import 'package:json_annotation/json_annotation.dart';

class OrderConfirmData {
  String? success;
  String? stringMessage;
  Message? message;

  OrderConfirmData({this.success, this.stringMessage, this.message});

  OrderConfirmData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (success == "false") {
      stringMessage = "Something went wrong";
      /* message = json['message'] != null
          ? new Message.fromJson(json['message'])
          : null;*/
    } else {
      stringMessage = json['message'];
    }
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
  List<String>? discount;
  List<String>? tranId;

  Message({this.discount, this.tranId});

  Message.fromJson(Map<String, dynamic> json) {
    List<String> emailEmptyMessage = [];
    emailEmptyMessage.add("");
    discount = json['discount'] != null
        ? json['discount'].cast<String>()
        : emailEmptyMessage;
    tranId = json['tran_id'] != null
        ? json['tran_id'].cast<String>()
        : emailEmptyMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount'] = this.discount;
    data['tran_id'] = this.tranId;
    return data;
  }
}
