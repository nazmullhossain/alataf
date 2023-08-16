class InfoData {
  List<Insertt>? insert;
  List<Update>? update;
  List<Delete>? delete;

  InfoData({this.insert, this.update, this.delete});

  InfoData.fromJson(Map<String, dynamic> json) {
    if (json['insert'] != null) {
      insert = <Insertt>[];
      json['insert'].forEach((v) {
        insert!.add(new Insertt.fromJson(v));
      });
    }
    if (json['update'] != null) {
      update = <Update>[];
      json['update'].forEach((v) {
        update!.add(new Update.fromJson(v));
      });
    }
    if (json['delete'] != null) {
      delete = <Delete>[];
      json['delete'].forEach((v) {
        delete!.add(new Delete.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.insert != null) {
      data['insert'] = this.insert!.map((v) => v.toJson()).toList();
    }
    if (this.update != null) {
      data['update'] = this.update!.map((v) => v.toJson()).toList();
    }
    if (this.delete != null) {
      data['delete'] = this.delete!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Insertt {
  int? id;
  String? name;
  String? bannerType;
  String? imageUrl;
  String? content;
  String? url;
  String? createdAt;

  Insertt(
      {this.id,
        this.name,
        this.bannerType,
        this.imageUrl,
        this.content,
        this.url,
        this.createdAt});

  Insertt.fromJson(Map<String, dynamic> json) {
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

class Update {
  int? id;
  String? name;
  String? bannerType;
  String? imageUrl;
  String? content;
  String? url;
  String? updatedAt;

  Update(
      {this.id,
        this.name,
        this.bannerType,
        this.imageUrl,
        this.content,
        this.url,
        this.updatedAt});

  Update.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    bannerType = json['banner_type'];
    imageUrl = json['image_url'];
    content = json['content'];
    url = json['url'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['banner_type'] = this.bannerType;
    data['image_url'] = this.imageUrl;
    data['content'] = this.content;
    data['url'] = this.url;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Delete {
  int? id;
  String? name;
  String? bannerType;
  String? imageUrl;
  String? content;
  String? url;

  Delete(
      {this.id,
        this.name,
        this.bannerType,
        this.imageUrl,
        this.content,
        this.url});

  Delete.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    bannerType = json['banner_type'];
    imageUrl = json['image_url'];
    content = json['content'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['banner_type'] = this.bannerType;
    data['image_url'] = this.imageUrl;
    data['content'] = this.content;
    data['url'] = this.url;
    return data;
  }
}