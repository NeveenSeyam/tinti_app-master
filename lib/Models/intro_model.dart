class IntroModel {
  List<Intros>? intros;
  String? message;

  IntroModel({this.intros, this.message});

  IntroModel.fromJson(Map<String, dynamic> json) {
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
  int? pageNumber;
  String? image;

  Intros({this.id, this.name, this.description, this.pageNumber, this.image});

  Intros.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    pageNumber = json['page_number'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['page_number'] = pageNumber;
    data['image'] = image;
    return data;
  }
}
