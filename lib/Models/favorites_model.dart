class FavoritesModel {
  List<FavoriteProducts>? favoriteProducts;
  String? message;

  FavoritesModel({this.favoriteProducts, this.message});

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    if (json['favorite_products'] != null) {
      favoriteProducts = <FavoriteProducts>[];
      json['favorite_products'].forEach((v) {
        favoriteProducts!.add(new FavoriteProducts.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.favoriteProducts != null) {
      data['favorite_products'] =
          this.favoriteProducts!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class FavoriteProducts {
  int? id;
  int? productId;
  String? name;
  String? description;
  String? price;
  String? salePrice;
  int? isSaled;
  String? service;
  String? company;
  String? image;

  FavoriteProducts(
      {this.id,
      this.productId,
      this.name,
      this.description,
      this.price,
      this.salePrice,
      this.isSaled,
      this.service,
      this.company,
      this.image});

  FavoriteProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    salePrice = json['sale_price'];
    isSaled = json['is_saled'];
    service = json['service'];
    company = json['company'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['sale_price'] = this.salePrice;
    data['is_saled'] = this.isSaled;
    data['service'] = this.service;
    data['company'] = this.company;
    data['image'] = this.image;
    return data;
  }
}
