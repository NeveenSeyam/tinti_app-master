class OrderDetailsModel {
  Order? order;
  String? message;

  OrderDetailsModel({this.order, this.message});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Order {
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
  String? paymentFlag;
  String? status;
  int? statusId;
  String? image;
  int? rating;
  String? ratingComments;

  Order(
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
      this.paymentFlag,
      this.status,
      this.statusId,
      this.image,
      this.rating,
      this.ratingComments});

  Order.fromJson(Map<String, dynamic> json) {
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
    paymentFlag = json['payment_flag'];
    status = json['status'];
    statusId = json['status_id'];
    image = json['image'];
    rating = json['rating'];
    ratingComments = json['rating_comments'];
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
    data['payment_flag'] = this.paymentFlag;
    data['status'] = this.status;
    data['status_id'] = this.statusId;
    data['image'] = this.image;
    data['rating'] = this.rating;
    data['rating_comments'] = this.ratingComments;
    return data;
  }
}
