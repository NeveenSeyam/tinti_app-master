class OrdeModel {
  List<Orders>? orders;
  String? message;

  OrdeModel({this.orders, this.message});

  OrdeModel.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Orders {
  int? id;
  int? productId;
  String? name;
  String? description;
  String? city;
  String? region;
  String? car;
  String? price;
  String? service;
  String? company;
  String? status;
  String? image;

  Orders(
      {this.id,
      this.productId,
      this.name,
      this.description,
      this.city,
      this.region,
      this.car,
      this.price,
      this.service,
      this.company,
      this.status,
      this.image});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    name = json['name'];
    description = json['description'];
    city = json['city'];
    region = json['region'];
    car = json['car'];
    price = json['price'];
    service = json['service'];
    company = json['company'];
    status = json['status'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['city'] = this.city;
    data['region'] = this.region;
    data['car'] = this.car;
    data['price'] = this.price;
    data['service'] = this.service;
    data['company'] = this.company;
    data['status'] = this.status;
    data['image'] = this.image;
    return data;
  }
}
