class ProductModel {
  Success? success;
  String? message;

  ProductModel({this.success, this.message});

  ProductModel.fromJson(Map<String, dynamic> json) {
    success =
        json['Success'] != null ? new Success.fromJson(json['Success']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.success != null) {
      data['Success'] = this.success!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Success {
  int? pageNumber;
  int? totalPages;
  int? totalRecords;
  List<Items>? items;

  Success({this.pageNumber, this.totalPages, this.totalRecords, this.items});

  Success.fromJson(Map<String, dynamic> json) {
    pageNumber = json['page_number'];
    totalPages = json['total_pages'];
    totalRecords = json['total_records'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_number'] = this.pageNumber;
    data['total_pages'] = this.totalPages;
    data['total_records'] = this.totalRecords;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? name;
  String? description;
  String? price;
  String? salePrice;
  String? service;
  String? rating;
  String? ratingCount;
  String? image;
  List<ProductRating>? productRating;
  List<Null>? productImages;

  Items(
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

  Items.fromJson(Map<String, dynamic> json) {
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
