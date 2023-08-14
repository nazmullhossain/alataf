class AdvertisementData {
  List<Insert>? insert;

  AdvertisementData({this.insert});

  AdvertisementData.fromJson(Map<String, dynamic> json) {
    if (json['insert'] != null) {
      insert = [];
      json['insert'].forEach((v) {
        insert?.add(new Insert.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.insert != null) {
      data['insert'] = this.insert?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Insert {
  int? id;
  String? name;
  String? bannerType;
  String? imageUrl;
  String? content;
  String? url;
  String? createdAt;

  Insert(
      {this.id,
      this.name,
      this.bannerType,
      this.imageUrl,
      this.content,
      this.url,
      this.createdAt});

  Insert.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    bannerType = json['banner_type'];
    imageUrl = json['image_url'];
    content = json['content'];
    url = json['url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['banner_type'] = this.bannerType;
    data['image_url'] = this.imageUrl;
    data['content'] = this.content;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    return data;
  }
}
