class PrescriptionModel {
  String? msg;
  String? url;

  PrescriptionModel({required this.msg,required this.url});

  PrescriptionModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['url'] = this.url;
    return data;
  }
}