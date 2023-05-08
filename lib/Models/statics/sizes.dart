class SizesModel {
  List<CarSizes>? carSizes;
  String? message;

  SizesModel({this.carSizes, this.message});

  SizesModel.fromJson(Map<String, dynamic> json) {
    if (json['car_sizes'] != null) {
      carSizes = <CarSizes>[];
      json['car_sizes'].forEach((v) {
        carSizes!.add(new CarSizes.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.carSizes != null) {
      data['car_sizes'] = this.carSizes!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class CarSizes {
  int? id;
  String? name;

  CarSizes({this.id, this.name});

  CarSizes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
