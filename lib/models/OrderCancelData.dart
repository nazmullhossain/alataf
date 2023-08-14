class OrderCancelData {
  String? message;
  String? success;

  OrderCancelData({this.message, this.success});

  OrderCancelData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
