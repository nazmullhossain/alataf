class OrderHistoryData {
  Data? data;

  OrderHistoryData({this.data});

  OrderHistoryData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  OrderList? orderList;

  Data({this.orderList});

  Data.fromJson(Map<String, dynamic> json) {
    orderList = json['order_list'] != null
        ? new OrderList.fromJson(json['order_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderList != null) {
      data['order_list'] = this.orderList?.toJson();
    }
    return data;
  }
}

class OrderList {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  String? nextPageUrl;
  String? prevPageUrl;
  int? from;
  int? to;
  List<Item>? data;

  OrderList(
      {this.total,
      this.perPage,
      this.currentPage,
      this.lastPage,
      this.nextPageUrl,
      this.prevPageUrl,
      this.from,
      this.to,
      this.data});

  OrderList.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];

    if (json['next_page_url'] == null) {
      nextPageUrl = "";
    } else {
      nextPageUrl = json['next_page_url'];
    }

    if (json['prev_page_url'] == null) {
      prevPageUrl = "";
    } else {
      prevPageUrl = json['prev_page_url'];
    }

    from = json['from'];
    to = json['to'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(new Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['next_page_url'] = this.nextPageUrl;
    data['prev_page_url'] = this.prevPageUrl;
    data['from'] = this.from;
    data['to'] = this.to;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  int? id;
  String? createdAt;
  String? updatedAt;
  double? totalAmount;
  int? totalVat;
  int? discount;
  String? remarks;
  int? status;
  String? address;
  String? tranId;
  String? prescription;
  String? prescriptionSrc;
  String? phone;
  List<Details>? orderDetails;

  Item(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.totalAmount,
      this.totalVat,
      this.discount,
      this.remarks,
      this.status,
      this.address,
      this.tranId,
      this.prescription,
      this.prescriptionSrc,
      this.phone,
      this.orderDetails});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalAmount = json['total_amount'].toDouble();
    totalVat = json['total_vat'];
    discount = json['discount'];
    remarks = json['remarks'];
    status = json['status'];
    address = json['address'];
    tranId = json['tran_id'];
    prescription = json['prescription'];
    phone = json['phone'] == null ? "" : json['phone'];
    if (prescription == "1") {
      prescriptionSrc = json['prescription_src'];
    }

    if (json['order_details'] != null) {
      orderDetails = [];
      json['order_details'].forEach((v) {
        orderDetails?.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total_amount'] = this.totalAmount;
    data['total_vat'] = this.totalVat;
    data['discount'] = this.discount;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
    data['address'] = this.address;
    data['tran_id'] = this.tranId;
    data['prescription'] = this.prescription;
    data['phone'] = this.phone;
    if (this.prescription == "1") {
      data['prescription_src'] = this.prescriptionSrc;
    }
    if (this.orderDetails != null) {
      data['order_details'] =
          this.orderDetails?.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Details {
  int? id;
  int? orderId;
  int? productId;
  int? quantity;
  double? unitPrice;
  int? unitVat;
  String? strength;
  String? productName;
  String? categoryName;
  String? unitName;
  String? genericName;

  Details(
      {this.id,
      this.orderId,
      this.productId,
      this.quantity,
      this.unitPrice,
      this.unitVat,
      this.strength,
      this.productName,
      this.categoryName,
      this.unitName,
      this.genericName});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    unitPrice = json['unit_price'].toDouble();
    unitVat = json['unit_vat'];
    strength = json['strength'];
    productName = json['product_name'];
    categoryName = json['category_name'];
    unitName = json['unit_name'] == null ? "" : json['unit_name'];
    genericName = json['generic_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['unit_price'] = this.unitPrice;
    data['unit_vat'] = this.unitVat;
    data['strength'] = this.strength;
    data['product_name'] = this.productName;
    data['category_name'] = this.categoryName;
    data['unit_name'] = this.unitName;
    data['generic_name'] = this.genericName;
    return data;
  }
}
