class SingleProductModel {
  Product? product;
  String? message;

  SingleProductModel({this.product, this.message});

  SingleProductModel.fromJson(Map<String, dynamic> json) {
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? description;
  String? price;
  String? salePrice;
  String? service;
  String? rating;
  String? ratingCount;
  String? image;
  List<Null>? productRating;
  List<Null>? productImages;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.salePrice,
      this.service,
      this.rating,
      this.ratingCount,
      this.image,
      this.productRating,
      this.productImages});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    salePrice = json['sale_price'];
    service = json['service'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['sale_price'] = this.salePrice;
    data['service'] = this.service;
    data['rating'] = this.rating;
    data['rating_count'] = this.ratingCount;
    data['image'] = this.image;

    return data;
  }
}
