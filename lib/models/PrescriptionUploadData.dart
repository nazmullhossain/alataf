class PrescriptionUploadData {
  String? msg;
  String? url;

  PrescriptionUploadData({ this.msg, this.url});

  PrescriptionUploadData.fromJson(Map<String, dynamic> json) {
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



// class UploadImage {
//   String? msg;
//   String? url;
//
//   UploadImage({this.msg, this.url});
//
//   UploadImage.fromJson(Map<String, dynamic> json) {
//     msg = json['msg'];
//     url = json['url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['msg'] = this.msg;
//     data['url'] = this.url;
//     return data;
//   }
// }
