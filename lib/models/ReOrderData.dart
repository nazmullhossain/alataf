class ReOrderData {
  Data? data;
  ReOrderData(this.data);
  ReOrderData.fromJson(Map<String, dynamic> json) {
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    if (data != null) data["data"] = this.data?.toJson();
    return data;
  }
}

class Data {
  OrderList? orderList;
  Data(this.orderList);

  Data.fromJson(Map<String, dynamic> json) {
    orderList = json["order_list"] != null
        ? OrderList.fromJson(json["order_list"])
        : null;
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data["order_list"] = this.orderList?.tojson();
    return data;
  }
}

class OrderList {
  int? total;
  int? per_page;
  int? current_page;
  int? last_page;
  String? next_page;
  String? prev_page;
  int? from;
  int? to;
  List<Items>? data;

  OrderList(this.total, this.per_page, this.current_page, this.last_page,
      this.next_page, this.prev_page, this.from, this.to, this.data);

  OrderList.fromJson(Map<String, dynamic> json) {
    total = json["total"];
    per_page = json["per_page"];
    current_page = json["current_page"];
    last_page = json["last_page"];
    next_page = json["next_page_url"] == null ? "" : json["next_page_url"];
    prev_page = json["prev_page_url"] == null ? "" : json["prev_page_url"];
    from = json["from"];
    to = json["to"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data?.add(Items.fromJson(v));
      });
    }
  }
  Map<String, dynamic> tojson() {
    var data = Map<String, dynamic>();
    data["total"] = total;
    data["per_page"] = per_page;
    data["current_page"] = current_page;
    data["last_page"] = last_page;
    data["next_page"] = next_page;
    data["pref_page"] = prev_page;
    data["from"] = from;
    data["to"] = to;
    data["data"] = this.data?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Items {
  int? id;
  int? total_amount;
  int? total_vat;
  int? discount;
  String? remarks;
  int? status;
  String? address;
  String? tranId;
  String? prescription;
  String? prescriptionSrc;
  List<Details>? details;
  Items(
      this.id,
      this.total_amount,
      this.total_vat,
      this.discount,
      this.remarks,
      this.status,
      this.address,
      this.tranId,
      this.prescription,
      this.prescriptionSrc,
      this.details);
  Items.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    total_amount = json["total_amount"];
    total_vat = json["total_vat"];
    discount = json["discount"];
    remarks = json["remarks"];
    status = json["status"];
    address = json["address"];
    tranId = json["tran_id"];
    prescription = json["prescription"];
    if (prescription == "1") prescriptionSrc = json["prescription_src"];
    if (json["order_details"] != null) {
      details = [];
      json["order_details"].forEach((v) {
        details?.add(Details.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data["id"] = id;
    data["total_amount"] = total_amount;
    data["total_vat"] = total_vat;
    data["discount"] = discount;
    data["remarks"] = remarks;
    data["status"] = status;
    data["address"] = address;
    data["tran_id"] = tranId;
    data["prescription"] = prescription;
    if (prescription == "1") data["prescription_src"] = prescriptionSrc;
    data["order_details"] = details?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Details {
  int? _orderId;
  int? _quantity;
  int? _unitPrice;
  int? _unitVat;
  String? _strength;
  String? _productName;
  String? _categoryName;
  String? _unitName;
  String? _genericName;

  Details(
      this._orderId,
      this._quantity,
      this._unitPrice,
      this._unitVat,
      this._strength,
      this._productName,
      this._categoryName,
      this._unitName,
      this._genericName);

  Details.fromJson(Map<String, dynamic> json) {
    print("$json");
    _orderId = json["order_id"];
    _quantity = json["quantity"];
    _unitPrice = json["unit_price"];
    _unitVat = json["unit_vat"];
    _strength = json["strength"];
    _productName = json["product_name"];
    _categoryName = json["category_name"];
    _unitName = json["unit_name"] == null ? "" : json["unit_name"];
    _genericName = json["generic_name"];
  }

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json["order_id"] = _orderId;
    json["quantity"] = _quantity;
    json["unit_price"] = _unitPrice;
    json["unit_vat"] = _unitVat;
    json["strength"] = _strength;
    json["product_name"] = _productName;
    json["category_name"] = _categoryName;
    json["unit_name"] = _unitName;
    json["generic_name"] = _genericName;
    return json;
  }
}


//int _orderId;
//int _quantity;
//int _unitPrice;
//int _unitVat;
//String _strength;
//String _productName;
//String _categoryName;
//String _unitName;
//String _genericName;
//
//ReOrderData(this._orderId,this._quantity,this._unitPrice,this._unitVat,this._strength,this._productName,this._categoryName,this._unitName,this._genericName);
//
//ReOrderData.fromJson(Map<String,dynamic> json){
//print("$json");
//_orderId = json["order_id"];
//_quantity = json["quantity"];
//_unitPrice = json["unit_price"];
//_unitVat = json["unit_vat"];
//_strength = json["strength"];
//_productName = json["product_name"];
//_categoryName = json["category_name"];
//_unitName = json["unit_name"];
//_genericName = json["generic_name"];
//}
//
//Map<String,dynamic> toJson(){
//  var json = Map<String,dynamic>();
//  json["order_id"] = _orderId;
//  json["quantity"] = _quantity;
//  json["unit_price"] = _unitPrice;
//  json["unit_vat"] = _unitVat;
//  json["strength"] = _strength;
//  json["product_name"] = _productName;
//  json["category_name"] = _categoryName;
//  json["unit_name"] = _unitName;
//  json["generic_name"] = _genericName;
//  return json;
//}
