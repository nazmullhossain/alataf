class ProfilesData {
  String? success;
  String? message;

  ProfilesData({this.success, this.message});

  ProfilesData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    try {
      message = json['message']?['mobile']?[0] ?? "Error occured";
    } catch (e) {
      message = json['message'] ?? "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}
