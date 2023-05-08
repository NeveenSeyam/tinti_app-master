class CarModel2 {
  List<CarModles>? carModles;
  String? message;

  CarModel2({this.carModles, this.message});

  CarModel2.fromJson(Map<String, dynamic> json) {
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
  String? fullName;

  CarModles({this.id, this.name, this.fullName});

  CarModles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['full_name'] = this.fullName;
    return data;
  }
}
