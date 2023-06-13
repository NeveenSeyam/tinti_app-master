class CarModelTaypesModel {
  List<CarModles>? carModles;
  String? message;

  CarModelTaypesModel({this.carModles, this.message});

  CarModelTaypesModel.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? code;

  CarModles({this.id, this.title, this.code});

  CarModles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['code'] = this.code;
    return data;
  }
}
