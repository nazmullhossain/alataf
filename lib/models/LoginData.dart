class LoginData {
  String? success;
  String? message;
  String? key;
  String? customerName;
  String? phone;
  String? email;
  int? gender;
  String? address;
  String? city;
  int? postcode;
  int? emailVerified;
  String? remarks;
  String? tradeLicence;
  String? shopName;

  LoginData(
      {this.success,
      this.message,
      this.key,
      this.customerName,
      this.phone,
      this.email,
      this.gender,
      this.address,
      this.city,
      this.postcode,
      this.emailVerified,
      this.tradeLicence,
      this.shopName});

  LoginData.fromJson(Map<String, dynamic> json) {
    print("login json -> ${json}");
    success = json['success'];
    message = json['message'];
    key = json['key'];
    customerName = json['customer_name'];
    phone = json['phone'];
    email = json['email'];
    gender = json['gender'];
    address = json['address'] == null ? "" : json['address'];
    city = "${json['city']}";
    postcode = json['postcode'];
    emailVerified = json['email_verified'];
    tradeLicence = json['trade_license'];
    shopName = json['shop_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['key'] = this.key;
    data['customer_name'] = this.customerName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['city'] = this.city;
    data['postcode'] = this.postcode;
    data['email_verified'] = this.emailVerified;
    return data;
  }
}
