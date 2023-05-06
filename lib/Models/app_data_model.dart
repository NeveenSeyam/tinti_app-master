class AppDataModel {
  List<Intros>? intros;
  String? message;

  AppDataModel({this.intros, this.message});

  AppDataModel.fromJson(Map<String, dynamic> json) {
    if (json['intros'] != null) {
      intros = <Intros>[];
      json['intros'].forEach((v) {
        intros!.add(new Intros.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.intros != null) {
      data['intros'] = this.intros!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Intros {
  int? id;
  String? name;
  String? description;

  Intros({this.id, this.name, this.description});

  Intros.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
