class CarModel {
  List<CarModles>? carModles;
  String? message;

  CarModel({this.carModles, this.message});

  CarModel.fromJson(Map<String, dynamic> json) {
    if (json['car_modles'] != null) {
      carModles = <CarModles>[];
      json['car_modles'].forEach((v) {
        carModles!.add(new CarModles.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.carModles != null) {
      data['car_modles'] = this.carModles!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class CarModles {
  int? id;
  String? name;
  String? color;
  String? carNumber;
  String? carModelName;
  String? carSizeName;
  String? image;

  CarModles(
      {this.id,
      this.name,
      this.color,
      this.carNumber,
      this.carModelName,
      this.carSizeName,
      this.image});

  CarModles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    carNumber = json['car_number'];
    carModelName = json['car_model_name'];
    carSizeName = json['car_size_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color'] = this.color;
    data['car_number'] = this.carNumber;
    data['car_model_name'] = this.carModelName;
    data['car_size_name'] = this.carSizeName;
    data['image'] = this.image;
    return data;
  }
}
