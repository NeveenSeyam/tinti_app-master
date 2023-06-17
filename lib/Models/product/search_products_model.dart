class SearchModel {
  List<Success>? success;
  String? message;

  SearchModel({this.success, this.message});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['Success'] != null) {
      success = <Success>[];
      json['Success'].forEach((v) {
        success!.add(new Success.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.success != null) {
      data['Success'] = this.success!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Success {
  int? id;
  String? name;
  String? description;
  int? isFavorite;
  String? price;
  String? salePrice;
  String? service;
  String? compnay;
  String? rating;
  String? ratingCount;
  String? image;
  List<ProductRating>? productRating;
  List<ProductImages>? productImages;

  Success(
      {this.id,
      this.name,
      this.description,
      this.isFavorite,
      this.price,
      this.salePrice,
      this.service,
      this.compnay,
      this.rating,
      this.ratingCount,
      this.image,
      this.productRating,
      this.productImages});

  Success.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isFavorite = json['is_favorite'];
    price = json['price'];
    salePrice = json['sale_price'];
    service = json['service'];
    compnay = json['compnay'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
    image = json['image'];
    if (json['product_rating'] != null) {
      productRating = <ProductRating>[];
      json['product_rating'].forEach((v) {
        productRating!.add(new ProductRating.fromJson(v));
      });
    }
    if (json['product_images'] != null) {
      productImages = <ProductImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(new ProductImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['is_favorite'] = this.isFavorite;
    data['price'] = this.price;
    data['sale_price'] = this.salePrice;
    data['service'] = this.service;
    data['compnay'] = this.compnay;
    data['rating'] = this.rating;
    data['rating_count'] = this.ratingCount;
    data['image'] = this.image;
    if (this.productRating != null) {
      data['product_rating'] =
          this.productRating!.map((v) => v.toJson()).toList();
    }
    if (this.productImages != null) {
      data['product_images'] =
          this.productImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductRating {
  int? id;
  String? rating;
  String? comments;
  String? user;

  ProductRating({this.id, this.rating, this.comments, this.user});

  ProductRating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    comments = json['comments'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['comments'] = this.comments;
    data['user'] = this.user;
    return data;
  }
}

class ProductImages {
  int? id;
  String? image;

  ProductImages({this.id, this.image});

  ProductImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}
