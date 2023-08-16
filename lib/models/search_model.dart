// class SearchModel {
//   Data? data;
//
//   SearchModel({this.data});
//
//   SearchModel.fromJson(Map<String, dynamic> json) {
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   int? total;
//   int? perPage;
//   int? currentPage;
//   int? lastPage;
//   Null? nextPageUrl;
//   Null? prevPageUrl;
//   int? from;
//   int? to;
//   List<Data>? data;
//
//   Data(
//       {this.total,
//         this.perPage,
//         this.currentPage,
//         this.lastPage,
//         this.nextPageUrl,
//         this.prevPageUrl,
//         this.from,
//         this.to,
//         this.data});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     total = json['total'];
//     perPage = json['per_page'];
//     currentPage = json['current_page'];
//     lastPage = json['last_page'];
//     nextPageUrl = json['next_page_url'];
//     prevPageUrl = json['prev_page_url'];
//     from = json['from'];
//     to = json['to'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['total'] = this.total;
//     data['per_page'] = this.perPage;
//     data['current_page'] = this.currentPage;
//     data['last_page'] = this.lastPage;
//     data['next_page_url'] = this.nextPageUrl;
//     data['prev_page_url'] = this.prevPageUrl;
//     data['from'] = this.from;
//     data['to'] = this.to;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ProductItem {
//   int? id;
//   String? productName;
//   int? vatPercent;
//   String? strength;
//   double? price;
//   String? genericName;
//   String? categoryName;
//   Null? unitName;
//   String? companyName;
//
//   ProductItem(
//       {this.id,
//         this.productName,
//         this.vatPercent,
//         this.strength,
//         this.price,
//         this.genericName,
//         this.categoryName,
//         this.unitName,
//         this.companyName});
//         // id = json['id'];
//
//   ProductItem.fromJson(Map<String, dynamic> json) {
//     productName = json['product_name'];
//     vatPercent = json['vat_percent'];
//     strength = json['strength'];
//     price = json['price'];
//     genericName = json['generic_name'];
//     categoryName = json['category_name'];
//     unitName = json['unit_name'];
//     companyName = json['company_name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['product_name'] = this.productName;
//     data['vat_percent'] = this.vatPercent;
//     data['strength'] = this.strength;
//     data['price'] = this.price;
//     data['generic_name'] = this.genericName;
//     data['category_name'] = this.categoryName;
//     data['unit_name'] = this.unitName;
//     data['company_name'] = this.companyName;
//     return data;
//   }
// }
